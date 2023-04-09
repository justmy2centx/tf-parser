# Create a new VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a new EKS cluster in the VPC
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  vpc_config {
    subnet_ids = aws_subnet.private.*.id
  }
  depends_on = [aws_iam_role_policy_attachment.eks_cluster, aws_security_group_rule.eks_cluster_ingress]
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
  version = "1.24"
}

# Create an IAM role and policy for the EKS cluster
resource "aws_iam_role" "eks_cluster" {
  name = "dev-eks-cluster"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

# Create security group for EKS cluster
resource "aws_security_group" "eks_cluster_sg" {
  name_prefix = "eks-cluster-sg-"
  vpc_id      = aws_vpc.eks_vpc.id
}

# Allow ingress from Github IP address ranges to the EKS cluster
resource "aws_security_group_rule" "eks_cluster_ingress" {
  security_group_id = aws_security_group.eks_cluster_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Create private subnets for the EKS cluster
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "private" {
  count      = 3
  cidr_block = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 4, count.index)
  vpc_id     = aws_vpc.eks_vpc.id

  availability_zone = element(data.aws_availability_zones.available.names, count.index)
}

# Create an ECR repository for the container registry
resource "aws_ecr_repository" "ecr_repo" {
  name = var.ecr_repo_name
}


resource "aws_iam_role" "ecr_role" {
  name               = "dev-ecr-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

# Attach AmazonEC2ContainerRegistryFullAccess policy to ECR role
resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  role       = aws_iam_role.ecr_role.name
}
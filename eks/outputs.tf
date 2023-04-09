# Output the EKS cluster endpoint and Kubernetes version
output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_version" {
  value = aws_eks_cluster.eks_cluster.version
}

# Output the variables
output "region" {
  value = var.region
}

output "cluster_name" {
  value = var.cluster_name
}

output "ecr_repo_name" {
  value = var.ecr_repo_name
}

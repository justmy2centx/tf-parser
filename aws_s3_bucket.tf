
provider "aws" {
    alias = "bucket_region"
    region = "eu-west-1"
}
  
resource "aws_s3_bucket" "example" {
  provider = aws.bucket_region
  bucket = "tripla-bucket"
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
   bucket = aws_s3_bucket.example.id
   acl = "private"
}

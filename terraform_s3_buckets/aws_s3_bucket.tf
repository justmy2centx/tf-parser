
provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "tripla-bucket"
}

resource "aws_s3_bucket_public_access_block" "example_public_access_block" {
  bucket_name = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

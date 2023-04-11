
provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "your_unique_bucket_name_here" {
  bucket = "your_unique_bucket_name_here"
}

resource "aws_s3_bucket_public_access_block" "your_unique_bucket_name_here_public_access_block" {
  bucket_name = aws_s3_bucket.your_unique_bucket_name_here.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

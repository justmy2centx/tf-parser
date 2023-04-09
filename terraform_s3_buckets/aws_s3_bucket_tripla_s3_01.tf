
provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "tripla_s3_01" {
  bucket = "tripla_s3_01"
}

resource "aws_s3_bucket_public_access_block" "tripla_s3_01_public_access_block" {
  bucket_name = aws_s3_bucket.tripla_s3_01.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

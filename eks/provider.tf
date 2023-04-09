# Configure the AWS provider
provider "aws" {
  region = var.region

}

terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "4.62.0"
    }

  }
  backend "s3" {
    bucket = "tripla-terraform-state-lucky"
    key    = "terraform.tfstate"
    region = "ap-southeast-1"
  }
}

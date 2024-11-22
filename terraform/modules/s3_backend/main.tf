provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}




resource "aws_s3_bucket" "backend" {
  bucket        = var.bucket_name
  acl           = "private"
  force_destroy = var.force_destroy

  versioning {
    enabled = true
  }

  tags = var.tags
}

resource "aws_dynamodb_table" "state_lock" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  hash_key = "LockID"

  tags = var.tags
}

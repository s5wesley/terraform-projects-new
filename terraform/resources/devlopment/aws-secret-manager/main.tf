provider "aws" {
  region = "us-east-1"
}

## Terraform block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # backend "s3" {
  #   bucket         = "development-s5wesley-tf-state"
  #   key            = "aws-secret-manager/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "development-s5wesley-tf-state-lock"
  #   encrypt        = true
  # }

}

module "aws-secret-manager" {
  source     = "../../../modules/aws-secret-manager"
  aws_region = "us-east-1"
  secret_names = [
    "DB_USERNAME",
    "DB_PASSWORD"
  ]
  tags = {
    id             = "1678"
    owner          = "s5wesley"
    environment    = "development"
    project        = "del"
    create_by      = "Terraform"
    cloud_provider = "aws"
    company        = "wesley"
  }
}

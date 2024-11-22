## Terraform block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  alias  = "main"
  region = local.aws_region
}

locals {
  aws_region    = "us-east-1"
  force_destroy = true
  common_tags = {
    "id"             = "1678"
    "owner"          = "s5wesley"
    "environment"    = "dev"
    "project"        = "devops"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
  }
}

module "ec2_instance" {
  source      = "../../../modules/ec2-instance"


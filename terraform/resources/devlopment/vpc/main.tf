provider "aws" {
  region = local.aws_region
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

locals {
  vpc_config = {
    vpc_cidr             = "10.0.0.0/16"
    public_subnet_count  = 4
    private_subnet_count = 4
    public_subnet_cidrs = [
      "10.0.1.0/24",
      "10.0.2.0/24",
      "10.0.3.0/24",
      "10.0.4.0/24"
    ]
    private_subnet_cidrs = [
      "10.0.5.0/24",
      "10.0.6.0/24",
      "10.0.7.0/24",
      "10.0.8.0/24"
    ]
    public_azs = [
      "us-east-1a",
      "us-east-1b",
      "us-east-1c",
      "us-east-1d"
    ]
    private_azs = [
      "us-east-1a",
      "us-east-1b",
      "us-east-1c",
      "us-east-1d"
    ]
    common_tags = {
      id             = "1678"
      owner          = "s5wesley"
      environment    = "dev"
      project        = "devops"
      created_by     = "Terraform"
      cloud_provider = "aws"
    }
  }

  aws_region = "us-east-1"
}

module "vpc" {
  source               = "../../../modules/vpc"
  vpc_cidr             = local.vpc_config.vpc_cidr
  public_subnet_count  = local.vpc_config.public_subnet_count
  private_subnet_count = local.vpc_config.private_subnet_count
  public_subnet_cidrs  = local.vpc_config.public_subnet_cidrs
  private_subnet_cidrs = local.vpc_config.private_subnet_cidrs
  public_azs           = local.vpc_config.public_azs
  private_azs          = local.vpc_config.private_azs
  common_tags          = local.vpc_config.common_tags
}

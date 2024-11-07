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
  source             = "../../../modules/ec2-instance"
  key_name           = var.key_name
  ami_id             = var.ami_id
  aws_region         = local.aws_region
  vpc_cidr           = var.vpc_cidr
  subnet1_cidr       = var.subnet1_cidr
  subnet2_cidr       = var.subnet2_cidr
  availability_zone1 = var.availability_zone1
  availability_zone2 = var.availability_zone2
  instance_type      = var.instance_type
  common_tags        = local.common_tags
}

# Output to retrieve instance details
output "instance_public_ip" {
  value = module.ec2_instance.instance_public_ip
}

output "vpc_id" {
  value = module.ec2_instance.vpc_id
}

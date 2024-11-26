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

# terraform {
#   backend "s3" {
#     bucket         = ""
#     dynamodb_table = ""
#     key            = ""
#     region         = ""
#   }
# }

locals {
  aws_region                    = "us-east-1"
  ec2_instance_ami              = "ami-0866a3c8686eaeeba"
  ec2_instance_type             = "t2.medium"
  sg_name                       = "ec2-instance-sg"
  instance_name                 = "ec2-instance"
  vpc_id                        = "vpc-057661e092e536f51"
  subnet_id                     = "subnet-07a75088ec09ac49a"
  root_volume_size              = 30
  instance_count                = 1
  enable_termination_protection = false
  ec2_instance_key_name         = "terraform-aws"
  allowed_ports = [
    22,
    80,
    8080
  ]
  tags = {
    "id"             = "1678"
    "owner"          = "s5wesley"
    "teams"          = "delta"
    "environment"    = "dev"
    "project"        = "del"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
  }
}

module "ec2-instance" {
  source                        = "../../../modules/ec2-instance"
  aws_region                    = local.aws_region
  ec2_instance_ami              = local.ec2_instance_ami
  ec2_instance_type             = local.ec2_instance_type
  sg_name                       = local.sg_name
  instance_name                 = local.instance_name
  ec2_instance_key_name         = local.ec2_instance_key_name
  vpc_id                        = local.vpc_id
  subnet_id                     = local.subnet_id
  root_volume_size              = local.root_volume_size
  instance_count                = local.instance_count
  allowed_ports                 = local.allowed_ports
  enable_termination_protection = local.enable_termination_protection
  tags                          = local.tags
}
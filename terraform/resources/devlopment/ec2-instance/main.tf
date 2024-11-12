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
  # key_name    = var.key_name
  # # ami_id      = data.aws_ami.jenkins_master_ami.id
  # aws_region  = local.aws_region
  # common_tags = local.common_tags
}

# # Output to retrieve instance details
# output "instance_public_ip" {
#   value = module.ec2_instance.instance_public_ip
# }

# output "vpc_id" {
#   value = module.ec2_instance.vpc_id
# }

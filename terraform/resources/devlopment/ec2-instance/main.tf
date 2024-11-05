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

locals {
  aws_region_main = "us-east-1"
  key_name        = "terraform-aws"
  common_tags = {
    "id"             = "1678"
    "owner"          = "s5wesley"
    "environment"    = "dev"
    "project"        = "devops"
    "create_by"      = "Terraform"
    "cloud_provider" = "aws"
  }
}

# Module for Jenkins and SonarQube setup
module "ec2-instance" {
  source     = "../../../modules/ec2-instance"
  aws_region = local.aws_region_main   # e.g., "us-east-1"
  ami_id     = "ami-0866a3c8686eaeeba" # specify your AMI ID

  instance_type = "t2.micro"            # specify your instance type
  subnet_id     = aws_subnet.example.id # ensure this is a valid subnet ID
  key_name      = local.key_name        # e.g., "terraform-aws"
  common_tags   = local.common_tags     # ensure this is a map of strings
  vpc_id        = aws_vpc.example.id    # ensure this is a valid VPC ID
}
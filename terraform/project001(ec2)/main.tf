provider "aws" {
  region = "us-east-1"
}

# Terraform configuration
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_instance" "ec2-vm" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"

  tags = {
    Name        = "Dev_VM"
    Environment = "Dev"
    Project     = "Project_001"
    Owner       = "s5wesley"
  }
}

output "instance_id" {
  value = aws_instance.ec2-vm.id
}

output "instance_ip" {
  value = aws_instance.ec2-vm.public_ip
}
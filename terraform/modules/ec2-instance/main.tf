# Provider Configuration
provider "aws" {
  region = var.aws_region
}

# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Define the VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = var.vpc_cidr

  tags = merge(
    var.common_tags,
    { Name = format("%s-%s-%s-vpc", var.common_tags["id"], var.common_tags["environment"], var.common_tags["project"]) }
  )
}

# Define the first subnet
resource "aws_subnet" "example_subnet1" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = var.subnet1_cidr
  availability_zone = var.availability_zone1

  tags = merge(
    var.common_tags,
    { Name = format("%s-%s-%s-subnet1", var.common_tags["id"], var.common_tags["environment"], var.common_tags["project"]) }
  )
}

# Define the second subnet
resource "aws_subnet" "example_subnet2" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = var.subnet2_cidr
  availability_zone = var.availability_zone2

  tags = merge(
    var.common_tags,
    { Name = format("%s-%s-%s-subnet2", var.common_tags["id"], var.common_tags["environment"], var.common_tags["project"]) }
  )
}

# Define the EC2 instance
resource "aws_instance" "example" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.example_subnet1.id
  associate_public_ip_address = true
  key_name                    = var.key_name

  # Use security group by ID
  security_group_ids = [aws_security_group.example_sg.id]

  tags = merge(
    var.common_tags,
    { Name = format("%s-%s-%s-ec2-instance", var.common_tags["id"], var.common_tags["environment"], var.common_tags["project"]) }
  )
}

# Define a security group for the instance with a formatted name
resource "aws_security_group" "example_sg" {
  name   = format("%s-%s-%s-ec2-sg", var.common_tags["id"], var.common_tags["environment"], var.common_tags["project"])
  vpc_id = aws_vpc.example_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows SSH from anywhere, restrict for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}

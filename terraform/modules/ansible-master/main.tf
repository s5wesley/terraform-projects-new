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

# VPC Configuration
resource "aws_vpc" "s5wesley_vpc" {
  cidr_block = var.vpc_cidr

  tags = merge(
    var.common_tags,
    { Name = format("%s-%s-%s-vpc", var.common_tags["id"], var.common_tags["environment"], var.common_tags["project"]) }
  )
}

# Internet Gateway Configuration
resource "aws_internet_gateway" "s5wesley_igw" {
  vpc_id = aws_vpc.s5wesley_vpc.id

  tags = merge(
    var.common_tags,
    { Name = format("%s-%s-%s-igw", var.common_tags["id"], var.common_tags["environment"], var.common_tags["project"]) }
  )
}

# Route Table Configuration
resource "aws_route_table" "s5wesley_route_table" {
  vpc_id = aws_vpc.s5wesley_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.s5wesley_igw.id
  }

  tags = merge(
    var.common_tags,
    { Name = format("%s-%s-%s-route-table", var.common_tags["id"], var.common_tags["environment"], var.common_tags["project"]) }
  )
}

# Subnet 1 Configuration
resource "aws_subnet" "s5wesley_subnet1" {
  vpc_id            = aws_vpc.s5wesley_vpc.id
  cidr_block        = var.subnet1_cidr
  availability_zone = var.availability_zone1

  tags = merge(
    var.common_tags,
    { Name = format("%s-%s-%s-subnet1", var.common_tags["id"], var.common_tags["environment"], var.common_tags["project"]) }
  )
}

# Subnet 2 Configuration
resource "aws_subnet" "s5wesley_subnet2" {
  vpc_id            = aws_vpc.s5wesley_vpc.id
  cidr_block        = var.subnet2_cidr
  availability_zone = var.availability_zone2

  tags = merge(
    var.common_tags,
    { Name = format("%s-%s-%s-subnet2", var.common_tags["id"], var.common_tags["environment"], var.common_tags["project"]) }
  )
}

# Route Table Association for Subnet 1
resource "aws_route_table_association" "s5wesley_route_assoc1" {
  subnet_id      = aws_subnet.s5wesley_subnet1.id
  route_table_id = aws_route_table.s5wesley_route_table.id
}

# Route Table Association for Subnet 2
resource "aws_route_table_association" "s5wesley_route_assoc2" {
  subnet_id      = aws_subnet.s5wesley_subnet2.id
  route_table_id = aws_route_table.s5wesley_route_table.id
}




resource "aws_instance" "ansible_vm" {
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.s5wesley_subnet1.id
  key_name      = var.key_name

  security_group_ids = [aws_security_group.s5wesley_sg.id]

  user_data = file("${path.module}/user_data.sh") # Ensure this file exists in the module directory

  iam_instance_profile = aws_iam_instance_profile.ansible_instance_profile.name

  tags = merge(
    var.common_tags,
    { Name = format("%s-%s-%s-ansible_master", var.common_tags["id"], var.common_tags["environment"], var.common_tags["project"]) }
  )
}

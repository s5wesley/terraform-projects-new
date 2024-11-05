variable "aws_region" {
  description = "AWS region to deploy resources."
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the instance."
  type        = string
}

variable "instance_type" {
  description = "The instance type to use."
  type        = string
}

variable "key_name" {
  description = "The name of the SSH key pair to use."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "subnet1_cidr" {
  description = "The CIDR block for the first subnet."
  type        = string
}

variable "subnet2_cidr" {
  description = "The CIDR block for the second subnet."
  type        = string
}

variable "availability_zone1" {
  description = "The first availability zone to use."
  type        = string
}

variable "availability_zone2" {
  description = "The second availability zone to use."
  type        = string
}

variable "common_tags" {
  description = "Common tags for resources."
  type        = map(string)
}

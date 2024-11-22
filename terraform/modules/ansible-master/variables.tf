variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet1_cidr" {
  description = "CIDR block for the first subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet2_cidr" {
  description = "CIDR block for the second subnet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone1" {
  description = "Availability zone for the first subnet."
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone2" {
  description = "Availability zone for the second subnet."
  type        = string
  default     = "us-east-1b"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance."
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "SSH key name to access the EC2 instance."
  type        = string
}

variable "user_data" {
  description = "Path to the user data script"
  type        = string
  default     = "user_data.sh"
}

variable "instance_name" {
  description = "Name to be used for the instance-related IAM resources"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources."
  type        = map(string)
  default = {
    id             = "1678"
    owner          = "s5wesley"
    environment    = "dev"
    project        = "devops"
    create_by      = "Terraform"
    cloud_provider = "aws"
  }
}

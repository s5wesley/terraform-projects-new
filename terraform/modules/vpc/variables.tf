variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
}

variable "private_subnet_count" {
  description = "Number of private subnets"
  type        = number
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "public_azs" {
  description = "List of availability zones for public subnets"
  type        = list(string)
}

variable "private_azs" {
  description = "List of availability zones for private subnets"
  type        = list(string)
}

variable "common_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

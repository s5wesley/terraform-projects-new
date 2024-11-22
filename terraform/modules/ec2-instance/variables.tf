variable "aws_region" {
    type = string
    default = "us-east-1"
}

variable "key_name" {
    type = string
    default = "ansible3"
}

variable "instance_type" {
    type = string
    default = "t2.medium"
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

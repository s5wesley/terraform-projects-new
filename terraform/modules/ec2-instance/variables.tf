# Define string variables
variable "aws_region" {
  type = string
}

variable "ec2_instance_ami" {
  type = string
}

variable "ec2_instance_type" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "root_volume_size" {
  type = number
}

variable "instance_count" {
  type = number
}

variable "instance_name" {
  type = string

}

variable "sg_name" {
  type = string

}

variable "ec2_instance_key_name" {
  type = string

}

variable "enable_termination_protection" {
  type = bool

}

variable "allowed_ports" {
  description = "List of allowed ports"
  type        = list(number)
}

variable "tags" {
  type = map(any)
}

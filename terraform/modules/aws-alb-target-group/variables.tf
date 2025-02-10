variable "region" {
  description = "AWS Region"
  type        = string
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB and target groups"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs for ALB"
  type        = list(string)
}

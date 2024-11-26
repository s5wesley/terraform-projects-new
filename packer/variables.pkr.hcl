variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ami_name" {
  type    = string
  default = "jenkins-server-ami"
}

variable "instance_name" {
  type    = string
  default = "jenkins_server"  # Default name for the instance
}
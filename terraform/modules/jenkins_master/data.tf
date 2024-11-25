data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["default-vpc"] # Replace with the actual Name tag value of your VPC
  }
}

data "aws_subnet" "subnet_01" {
  filter {
    name   = "tag:Name"
    values = ["default-subnet01"]
  }
}

data "aws_security_group" "sg" {
  filter {
    name   = "tag:Name"
    values = ["Jenkins-master"]
  }
}

data "aws_ami" "jenkins_master_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["jenkins-master"]
  }
}
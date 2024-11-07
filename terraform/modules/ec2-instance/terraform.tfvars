key_name           = "terraform-aws"
ami_id             = "ami-0866a3c8686eaeeba"
aws_region         = "us-east-1"
vpc_cidr           = "10.0.0.0/16"
subnet1_cidr       = "10.0.1.0/24"
subnet2_cidr       = "10.0.2.0/24"
availability_zone1 = "us-east-1a"
availability_zone2 = "us-east-1b"
instance_type      = "t2.medium"

common_tags = {
  id             = "1678"
  owner          = "s5wesley"
  environment    = "dev"
  project        = "devops"
  create_by      = "Terraform"
  cloud_provider = "aws"
}

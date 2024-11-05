aws_region         = "us-east-1"             # Specify your AWS region
vpc_cidr           = "10.0.0.0/16"           # CIDR block for the VPC
subnet1_cidr       = "10.0.1.0/24"           # CIDR block for the first subnet
subnet2_cidr       = "10.0.2.0/24"           # CIDR block for the second subnet
availability_zone1 = "us-east-1a"            # First availability zone
availability_zone2 = "us-east-1b"            # Second availability zone
ami_id             = "ami-0866a3c8686eaeeba" # AMI ID for the EC2 instance
instance_type      = "t2.medium"             # Instance type
key_name           = "terraform-aws"         # Key name for SSH access
common_tags = {
  id             = "1678"      # Common ID tag
  owner          = "s5wesley"  # Owner tag
  environment    = "dev"       # Environment tag
  project        = "devops"    # Project tag
  create_by      = "Terraform" # Creator tag
  cloud_provider = "aws"       # Cloud provider tag
}

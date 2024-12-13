terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

locals {
  common_tags = {
    id             = "1678"
    owner          = "s5wesley"
    environment    = "development"
    project        = "del"
    create_by      = "Terraform"
    cloud_provider = "aws"
    company        = "wesley"
  }
}

module "my_secret" {
  source             = "../../../modules/aws-secret-manager" # Path to the module
  secret_name        = "my_database_secret"
  secret_description = "This is a description of my secret"
  name               = "DB_USERNAME"     # Replace with your actual name
  password           = "DB_PASSWORD"     # Replace with your actual password
  tags               = local.common_tags # Passing tags to the module
}
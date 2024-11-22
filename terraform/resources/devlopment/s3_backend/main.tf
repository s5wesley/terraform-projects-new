terraform {
  backend "s3" {
    bucket         = "s5wesley_s3bucket"
    key            = "terraform/state"
    region         = "us-east-1"
    dynamodb_table = "s5wesley_s3bucket_backend"
  }
}

module "s3_backend" {
  source              = "../../../modules/s3_backend"
  bucket_name         = "s5wesley_s3bucket"
  dynamodb_table_name = "s5wesley_s3bucket_backend"
  force_destroy       = true
  tags = {
    id             = "1678"
    owner          = "s5wesley"
    environment    = "dev"
    project        = "devops"
    create_by      = "Terraform"
    cloud_provider = "aws"
  }
}

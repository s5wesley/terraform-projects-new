


module "ansible-master" {
  source        = "../../../modules/ansible-master"
  ami_id        = var.ami_id # Ubuntu 20.04 AMI in us-east-1
  instance_type = var.instance_type
  key_name      = var.key_name
  instance_name = "ansible-master"
}

source "amazon-ebs" "jenkins" {
  region        = var.aws_region
  instance_type = "t2.micro"
  source_ami_filter {
    filters = {
      "virtualization-type" = "hvm"
      "name"                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      "root-device-type"    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
  ssh_username = "ubuntu"
  ami_name     = var.ami_name

  tags = {
    Name                = var.instance_name
    Jenkins-server-ami  = "true"
  }
}

build {
  sources = [
    "source.amazon-ebs.jenkins"
  ]

  provisioner "shell" {
    script = "jenkins.sh"
  }
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.jenkins_master_ami.id
  instance_type = var.instance_type

  # Add a key pair for SSH access
  key_name = var.key_name

  # Security Group to allow SSH and HTTP access
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # Associate instance with specific subnet
  subnet_id = data.aws_subnet.default-subnet01.id

  # Specify the root block device to set the volume size to 30 GB and type to gp3
  root_block_device {
    volume_size = 30      # Size in GB
    volume_type = "gp3"   # Set volume type to gp3
  }

  tags = merge(var.common_tags, {
    Name = "jenkins-master"
  })
}
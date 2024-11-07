output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.s5wesley_instance.public_ip
}

output "vpc_id" {
  description = "VPC ID where the EC2 instance is deployed"
  value       = aws_vpc.s5wesley_vpc.id
}

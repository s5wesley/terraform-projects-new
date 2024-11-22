output "ansible_vm_ec2_role_name" {
  description = "Name of the IAM Role attached to the Ansible VM with EC2 access"
  value       = aws_iam_role.ansible_role.name
}

output "ansible_vm_ec2_policy_arn" {
  description = "ARN of the EC2 full-access policy attached to the Ansible VM"
  value       = aws_iam_policy.ec2_full_access_policy.arn
}

output "ansible_vm_public_ip" {
  description = "Public IP address of the Ansible VM"
  value       = aws_instance.ansible_vm.public_ip
}

output "ansible_vm_instance_id" {
  description = "Instance ID of the Ansible VM"
  value       = aws_instance.ansible_vm.id
}

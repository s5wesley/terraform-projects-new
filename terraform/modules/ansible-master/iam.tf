resource "aws_iam_role" "ansible_role" {
  name = "${var.instance_name}_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = var.common_tags
}

resource "aws_iam_policy" "ec2_full_access_policy" {
  name        = "${var.instance_name}_ec2_full_access_policy"
  description = "Policy granting full EC2 access to the Ansible master"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ec2:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ec2_policy_attachment" {
  name       = "${var.instance_name}_policy_attachment"
  roles      = [aws_iam_role.ansible_role.name]
  policy_arn = aws_iam_policy.ec2_full_access_policy.arn
}

resource "aws_iam_instance_profile" "ansible_instance_profile" {
  name = "${var.instance_name}_instance_profile"
  role = aws_iam_role.ansible_role.name
}

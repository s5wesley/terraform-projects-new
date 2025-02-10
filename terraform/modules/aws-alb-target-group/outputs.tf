output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.this.dns_name
}

output "blue_target_group_arn" {
  description = "ARN of the Blue target group"
  value       = aws_lb_target_group.blue.arn
}

output "green_target_group_arn" {
  description = "ARN of the Green target group"
  value       = aws_lb_target_group.green.arn
}

output "red_target_group_arn" {
  description = "ARN of the Red target group"
  value       = aws_lb_target_group.red.arn
}

output "yellow_target_group_arn" {
  description = "ARN of the Yellow target group"
  value       = aws_lb_target_group.yellow.arn
}

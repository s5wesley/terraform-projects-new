resource "aws_secretsmanager_secret" "secrets" {
  for_each                = toset(var.secret_names)
  recovery_window_in_days = 0
  name                    = each.key
  tags                    = var.tags
}
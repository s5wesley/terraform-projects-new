resource "aws_secretsmanager_secret" "this" {
  name                    = var.secret_name
  description             = var.secret_description
  recovery_window_in_days = 0
  tags                    = var.tags # Assigning tags to the secret
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    name     = var.name
    password = var.password
  }) # Storing name and password as a JSON object
}

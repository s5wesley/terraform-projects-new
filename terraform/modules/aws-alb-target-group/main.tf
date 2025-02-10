provider "aws" {
  region = var.region
}

# Application Load Balancer
resource "aws_lb" "this" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnets
}

# Target Groups
resource "aws_lb_target_group" "blue" {
  name     = "${var.alb_name}-blue"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "green" {
  name     = "${var.alb_name}-green"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "red" {
  name     = "${var.alb_name}-red"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "yellow" {
  name     = "${var.alb_name}-yellow"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# HTTP Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid request"
      status_code  = "404"
    }
  }
}

# Listener Rules (Fixed Syntax)
resource "aws_lb_listener_rule" "blue_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["/blue/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

resource "aws_lb_listener_rule" "green_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 200

  condition {
    path_pattern {
      values = ["/green/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }
}

resource "aws_lb_listener_rule" "red_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 300

  condition {
    path_pattern {
      values = ["/red/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.red.arn
  }
}

resource "aws_lb_listener_rule" "yellow_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 400

  condition {
    path_pattern {
      values = ["/yellow/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.yellow.arn
  }
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.alb_name}-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

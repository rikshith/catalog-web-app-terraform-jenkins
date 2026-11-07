resource "aws_lb" "app" {
  #checkov:skip=CKV2_AWS_20:HTTPS redirect is deferred because this lab has no domain or ACM certificate.
  #checkov:skip=CKV_AWS_91:Access logs are omitted in this disposable learning stack to avoid extra S3 storage and logging costs.
  #checkov:skip=CKV_AWS_150:Deletion protection is disabled so Terraform can destroy the dev stack.
  #checkov:skip=CKV2_AWS_28:WAF is omitted from this learning stack to avoid additional cost.
  name                       = "${var.name}-alb"
  internal                   = false
  load_balancer_type         = "application"
  drop_invalid_header_fields = true
  enable_deletion_protection = false
  security_groups            = [var.security_group_id]
  subnets                    = var.public_subnet_ids

  tags = {
    Name = "${var.name}-alb"
  }
}

resource "aws_lb_target_group" "app" {
  #checkov:skip=CKV_AWS_378:HTTP is used only between the ALB and app instances inside the VPC.
  name        = "${var.name}-tg"
  port        = var.target_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    path                = var.health_check_path
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.name}-tg"
  }
}

resource "aws_lb_listener" "http" {
  #checkov:skip=CKV_AWS_2:This lab has no domain or ACM certificate, so the public demo currently uses HTTP.
  #checkov:skip=CKV2_AWS_20:HTTPS redirect is deferred until a domain and certificate are configured.
  #checkov:skip=CKV_AWS_103:No HTTPS listener or TLS policy is configured for this HTTP-only lab.
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = {
    Name = "${var.name}-http-listener"
  }
}
resource "aws_security_group" "alb" {
  #checkov:skip=CKV_AWS_260:Public HTTP on port 80 is intentional for this temporary learning demo.
  #checkov:skip=CKV2_AWS_5:This group is passed to the ALB through the root module; Checkov does not resolve that cross-module attachment.
  name        = "${var.name}-alb"
  description = "Allow public HTTP traffic to the application load balancer."
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Application traffic to targets within the VPC"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "${var.name}-alb"
  }
}

resource "aws_security_group" "app" {
  #checkov:skip=CKV2_AWS_5:This group is passed to the Auto Scaling group through the root module; Checkov does not resolve that cross-module attachment.
  name        = "${var.name}-app"
  description = "Allow application traffic only from the load balancer."
  vpc_id      = var.vpc_id

  ingress {
    description     = "Application traffic from the ALB"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "HTTPS for ECR, Secrets Manager, and package downloads"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "PostgreSQL traffic within the VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "${var.name}-app"
  }
}

resource "aws_security_group" "database" {
  #checkov:skip=CKV2_AWS_5:This group is passed to the RDS module through the root module; Checkov does not resolve that cross-module attachment.
  name        = "${var.name}-database"
  description = "Allow PostgreSQL traffic only from the application instances."
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from the application instances"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  tags = {
    Name = "${var.name}-database"
  }
}
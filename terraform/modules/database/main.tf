resource "aws_db_subnet_group" "app" {
  name        = "${var.name}-db-subnets"
  description = "Private subnets for the application database."
  subnet_ids  = var.subnet_ids

  tags = {
    Name = "${var.name}-db-subnets"
  }
}

resource "aws_db_instance" "app" {
  identifier     = "${var.name}-postgres"
  engine         = "postgres"
  instance_class = var.instance_class

  db_name  = var.database_name
  username = var.master_username

  manage_master_user_password = true

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  db_subnet_group_name   = aws_db_subnet_group.app.name
  vpc_security_group_ids = [var.security_group_id]
  publicly_accessible    = false

  multi_az                   = var.multi_az
  backup_retention_period    = 1
  auto_minor_version_upgrade = true
  deletion_protection        = false
  skip_final_snapshot        = true

  tags = {
    Name = "${var.name}-postgres"
  }
}
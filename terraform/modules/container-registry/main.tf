resource "aws_ecr_repository" "app" {
  #checkov:skip=CKV_AWS_136:The repository uses AES256 encryption; a customer-managed KMS key is unnecessary for this learning image.
  name                 = var.name
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name = var.name
  }
}
data "aws_caller_identity" "current" {}

locals {
  state_bucket_name = lower(
    "${var.project_name}-tfstate-${data.aws_caller_identity.current.account_id}-${var.aws_region}"
  )
}

resource "aws_s3_bucket" "terraform_state" {
  #checkov:skip=CKV2_AWS_62:This Terraform state bucket does not need event notifications.
  #checkov:skip=CKV2_AWS_61:S3 versioning is enabled; lifecycle expiration is omitted to preserve state history.
  #checkov:skip=CKV_AWS_18:Access logging would require a separate log bucket and add storage and request costs.
  #checkov:skip=CKV_AWS_144:Cross-region replication adds cost and is outside this single-region learning setup.
  #checkov:skip=CKV_AWS_145:The bucket uses SSE-S3 AES256; a customer-managed KMS key is unnecessary for this lab.
  bucket = local.state_bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_lock" {
  #checkov:skip=CKV_AWS_28:This table stores transient Terraform locks and can be recreated; point-in-time recovery is not needed.
  #checkov:skip=CKV_AWS_119:The lock table contains no application data; a customer-managed KMS key is outside this lab's scope.
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }
}
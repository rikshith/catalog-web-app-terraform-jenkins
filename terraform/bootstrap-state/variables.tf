variable "aws_region" {
  description = "AWS Region for the Terraform state resources"
  type        = string
  default     = "ap-south-2"
}

variable "project_name" {
  description = "Project name used in the state bucket name"
  type        = string
  default     = "catalog-web-app"
}

variable "lock_table_name" {
  description = "DynamoDB table name for Terraform state locking"
  type        = string
  default     = "catalog-web-app-terraform-locks"
}
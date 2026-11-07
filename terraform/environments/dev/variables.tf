variable "aws_region" {
  description = "AWS Region for the development environment"
  type        = string
  default     = "ap-south-2"
}

variable "project_name" {
  description = "Name used to identify this project"
  type        = string
  default     = "catalog-web-app"
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "dev"
}

variable "alert_email" {
  description = "Email address for CloudWatch alarm notifications."
  type        = string
  sensitive   = true

}
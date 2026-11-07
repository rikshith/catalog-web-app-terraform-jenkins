variable "name" {
  description = "Name prefix for the application compute resources."
  type        = string
}

variable "aws_region" {
  description = "AWS Region where the resources are deployed."
  type        = string
}

variable "image_uri" {
  description = "Full ECR image URI, including its immutable tag."
  type        = string
}

variable "subnet_ids" {
  description = "Private app subnet IDs for the Auto Scaling group."
  type        = list(string)
}

variable "app_security_group_id" {
  description = "Security group ID attached to the app instances."
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN for the app instances."
  type        = string
}

variable "database_address" {
  description = "RDS endpoint hostname."
  type        = string
}

variable "database_port" {
  description = "RDS port."
  type        = number
}

variable "database_name" {
  description = "Application database name."
  type        = string
}

variable "database_secret_arn" {
  description = "Secrets Manager ARN containing the RDS credentials."
  type        = string
}

variable "database_init_sql_base64" {
  description = "Base64-encoded SQL used to initialize the application database."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the app servers."
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum number of app instances."
  type        = number
  default     = 1
}

variable "desired_size" {
  description = "Initial desired number of app instances."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of app instances."
  type        = number
  default     = 2
}

variable "repository_arn" {
  description = "ARN of the ECR repository containing the application image."
  type        = string
}
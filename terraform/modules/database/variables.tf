variable "name" {
  description = "Name prefix for the database resources."
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for the database subnet group."
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID attached to the database."
  type        = string
}

variable "database_name" {
  description = "Name of the application database."
  type        = string
  default     = "catalog"
}

variable "master_username" {
  description = "Master username for the database."
  type        = string
  default     = "catalog_admin"
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t4g.micro"
}

variable "multi_az" {
  description = "Whether to enable a standby database instance in another Availability Zone."
  type        = bool
  default     = false
}
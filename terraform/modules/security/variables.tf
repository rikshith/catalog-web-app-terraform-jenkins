variable "name" {
  description = "Name prefix for the security groups."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the security groups will be created."
  type        = string
}

variable "app_port" {
  description = "Port the application instances listen on."
  type        = number
  default     = 8080
}
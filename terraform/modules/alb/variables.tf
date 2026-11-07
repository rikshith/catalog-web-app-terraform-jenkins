variable "name" {
  description = "Name prefix for the load balancer resources."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the load balancer and target group will be created."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs where the load balancer will be placed."
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID attached to the load balancer."
  type        = string
}

variable "target_port" {
  description = "Port the application instances listen on."
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "HTTP path the load balancer checks to determine instance health."
  type        = string
  default     = "/health"
}
variable "name" {
  description = "Name prefix for monitoring resources."
  type        = string
}

variable "aws_region" {
  description = "AWS Region containing the monitored resources."
  type        = string
}

variable "autoscaling_group_name" {
  description = "Name of the Auto Scaling group to monitor."
  type        = string
}

variable "load_balancer_arn" {
  description = "ARN of the Application Load Balancer to monitor."
  type        = string
}

variable "alert_email" {
  description = "Email address for monitoring notifications."
  type        = string
  sensitive   = true
}
output "load_balancer_arn" {
  description = "ARN of the application load balancer."
  value       = aws_lb.app.arn
}

output "load_balancer_dns_name" {
  description = "Public DNS name of the application load balancer."
  value       = aws_lb.app.dns_name
}

output "target_group_arn" {
  description = "ARN of the target group used by the application instances."
  value       = aws_lb_target_group.app.arn
}
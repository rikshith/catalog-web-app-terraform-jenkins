output "autoscaling_group_name" {
  description = "Name of the application Auto Scaling group."
  value       = aws_autoscaling_group.app.name
}

output "launch_template_id" {
  description = "ID of the launch template used by the app instances."
  value       = aws_launch_template.app.id
}

output "instance_role_arn" {
  description = "ARN of the IAM role attached to the app instances."
  value       = aws_iam_role.app.arn
}
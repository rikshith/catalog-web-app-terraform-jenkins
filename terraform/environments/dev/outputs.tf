output "vpc_id" {
  description = "ID of the development VPC"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.network.public_subnet_ids
}

output "app_subnet_ids" {
  description = "IDs of the private application subnets"
  value       = module.network.app_subnet_ids
}

output "database_subnet_ids" {
  description = "IDs of the private database subnets"
  value       = module.network.database_subnet_ids
}

output "nat_gateway_id" {
  description = "ID of the NAT gateway"
  value       = module.network.nat_gateway_id
}

output "alb_security_group_id" {
  description = "Security group ID for the application load balancer."
  value       = module.security.alb_security_group_id
}

output "app_security_group_id" {
  description = "Security group ID for the application instances."
  value       = module.security.app_security_group_id
}

output "load_balancer_dns_name" {
  description = "Public DNS name of the application load balancer."
  value       = module.alb.load_balancer_dns_name
}

output "target_group_arn" {
  description = "Target group ARN to connect to the Auto Scaling group."
  value       = module.alb.target_group_arn
}

output "database_security_group_id" {
  description = "Security group ID for the database."
  value       = module.security.database_security_group_id
}

output "database_address" {
  description = "Hostname of the application database."
  value       = module.database.database_address
}

output "database_port" {
  description = "Port used by the application database."
  value       = module.database.database_port
}

output "database_name" {
  description = "Name of the application database."
  value       = module.database.database_name
}

output "master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the database credentials."
  value       = module.database.master_user_secret_arn
}

output "container_image_repository_url" {
  description = "ECR repository URL for the application image."
  value       = module.container_registry.repository_url
}

output "container_image_repository_arn" {
  description = "ECR repository ARN for the application image."
  value       = module.container_registry.repository_arn
}

output "autoscaling_group_name" {
  description = "Name of the application Auto Scaling group."
  value       = module.compute.autoscaling_group_name
}

output "app_instance_role_arn" {
  description = "IAM role ARN attached to the application instances."
  value       = module.compute.instance_role_arn
}
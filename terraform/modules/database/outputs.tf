output "database_address" {
  description = "Hostname of the application database."
  value       = aws_db_instance.app.address
}

output "database_port" {
  description = "Port used by the application database."
  value       = aws_db_instance.app.port
}

output "database_name" {
  description = "Name of the application database."
  value       = aws_db_instance.app.db_name
}

output "master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the database master credentials."
  value       = aws_db_instance.app.master_user_secret[0].secret_arn
}
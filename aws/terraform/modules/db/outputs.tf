output "db_instance_id" {
  value = aws_db_instance.mysql.id
}

output "db_endpoint" {
  value = aws_db_instance.mysql.address
}

output "db_password" {
  description = "Generated DB password (sensitive) or provided one"
  value       = (var.db_password != null && var.db_password != "") ? var.db_password : random_password.db.result
  sensitive   = true
}

output "db_arn" {
  description = "ARN of the RDS instance"
  value       = aws_db_instance.mysql.arn
}

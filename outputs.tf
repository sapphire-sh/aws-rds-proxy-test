output "rds_endpoint" {
  value = aws_db_instance.main.address
}

output "rds_name" {
  value = aws_db_instance.main.name
}

output "rds_port" {
  value = aws_db_instance.main.port
}

output "rds_username" {
  value = aws_db_instance.main.username
}

output "rds_password" {
  value = var.password
}

output "rds_proxy_endpoint" {
  value = aws_db_proxy.main.endpoint
}

output "secret_values" {
  value = jsondecode(aws_secretsmanager_secret_version.main.secret_string)
}

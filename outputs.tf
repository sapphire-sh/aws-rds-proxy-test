output "mysql_endpoint" {
  value = aws_db_instance.proxy-test.address
}

output "mysql_name" {
  value = aws_db_instance.proxy-test.name
}

output "mysql_port" {
  value = aws_db_instance.proxy-test.port
}

output "mysql_username" {
  value = aws_db_instance.proxy-test.username
}

output "mysql_password" {
  value = var.password
}

locals {
  aws_rds_name     = aws_db_instance.main.name
  aws_rds_username = aws_db_instance.main.username
  aws_rds_password = aws_db_instance.main.password
  aws_rds_port     = aws_db_instance.main.port
  aws_rds_endpoint = aws_db_instance.main.address
}

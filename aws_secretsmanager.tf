resource "aws_secretsmanager_secret" "main" {
  name                    = var.name
  recovery_window_in_days = 0

  tags = {
    Name = var.name
  }
}

resource "aws_secretsmanager_secret_version" "main" {
  secret_id = aws_secretsmanager_secret.main.id
  secret_string = jsonencode({
    username            = var.user,
    password            = local.aws_rds_password,
    engine              = "mysql",
    host                = local.aws_rds_endpoint,
    port                = 3306,
    dbname              = local.aws_rds_username
    dbClusterIdentifier = local.aws_rds_name
  })
}

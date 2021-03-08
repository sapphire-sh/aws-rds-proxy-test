resource "aws_db_subnet_group" "main" {
  name       = var.name
  subnet_ids = aws_subnet.main_public.*.id

  tags = {
    Name = var.name
  }
}

resource "aws_db_instance" "main" {
  name                   = var.user
  identifier             = var.name
  username               = var.user
  password               = var.password
  parameter_group_name   = aws_db_parameter_group.main.name
  instance_class         = "db.t2.micro"
  allocated_storage      = 40
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  publicly_accessible    = true
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.main.id
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = var.name
  }
}

resource "aws_db_parameter_group" "main" {
  name   = var.name
  family = "mysql5.7"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }

  parameter {
    name  = "collation_server"
    value = "utf8_general_ci"
  }

  tags = {
    Name = var.name
  }
}

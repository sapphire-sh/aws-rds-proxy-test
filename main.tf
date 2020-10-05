provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_db_instance" "proxy-test" {
  name                 = var.user
  identifier           = var.name
  username             = var.user
  password             = var.password
  parameter_group_name = aws_db_parameter_group.proxy-test.name
  instance_class       = "db.t2.micro"
  allocated_storage    = 40
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  publicly_accessible  = true
  skip_final_snapshot  = true

  tags = {
    Name = var.name
  }
}

resource "aws_db_parameter_group" "proxy-test" {
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
}

data "aws_availability_zones" "main" {
  state = "available"
}

module "subnet_addrs_public" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = "10.0.1.0/24"
  networks = [for x in data.aws_availability_zones.main.names : {
    name     = x
    new_bits = 4
  }]
}

module "subnet_addrs_private" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = "10.0.2.0/24"
  networks = [for x in data.aws_availability_zones.main.names : {
    name     = x
    new_bits = 4
  }]
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = var.name
  }
}

locals {
  az_count = length(data.aws_availability_zones.main.names)
}

resource "aws_subnet" "main_public" {
  count = local.az_count

  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.main.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 16 + count.index)

  tags = {
    Name = "${var.name}-public"
    Tier = "public"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.name
  }
}

resource "aws_route_table" "main_public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_route_table_association" "main_public" {
  count = local.az_count

  subnet_id      = aws_subnet.main_public[count.index].id
  route_table_id = aws_route_table.main_public.id
}

resource "aws_subnet" "main_private" {
  count = local.az_count

  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.main.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)

  tags = {
    Name = "${var.name}-private"
    Tier = "private"
  }
}

resource "aws_eip" "main" {
  vpc = true

  tags = {
    Name = var.name
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.main_public[0].id

  tags = {
    Name = var.name
  }
}

resource "aws_route_table" "main_private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.name}-private"
  }
}

resource "aws_route_table_association" "main_private" {
  count = local.az_count

  subnet_id      = aws_subnet.main_private[count.index].id
  route_table_id = aws_route_table.main_private.id
}

resource "aws_security_group" "main" {
  name   = var.name
  vpc_id = aws_vpc.main.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.name
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "use1"
}

data "aws_route53_zone" "main" {
  name         = "${var.root}."
  private_zone = false
}

data "aws_acm_certificate" "main" {
  provider = aws.use1
  domain   = "*.api.${var.root}"
}

data "aws_acm_certificate" "main_region" {
  domain = "*.${var.region}.api.${var.root}"
}

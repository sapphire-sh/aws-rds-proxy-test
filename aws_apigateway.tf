resource "aws_api_gateway_domain_name" "main_server" {
  certificate_arn = data.aws_acm_certificate.main.arn
  domain_name     = "${var.stage}-server.api.${var.root}"

  tags = {
    Name = var.name
  }
}

resource "aws_apigatewayv2_domain_name" "main_server_ws" {
  domain_name = "${var.stage}-server-ws.${var.region}.api.${var.root}"

  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.main_region.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = {
    Name = var.name
  }
}

resource "aws_route53_record" "main_server" {
  name    = aws_api_gateway_domain_name.main_server.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.main.id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.main_server.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.main_server.cloudfront_zone_id
  }
}

resource "aws_route53_record" "main_server_ws" {
  name    = aws_apigatewayv2_domain_name.main_server_ws.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.main.id

  alias {
    evaluate_target_health = true
    name                   = aws_apigatewayv2_domain_name.main_server_ws.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.main_server_ws.domain_name_configuration[0].hosted_zone_id
  }
}


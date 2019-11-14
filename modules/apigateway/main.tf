# API Gateway custom domains can only use ACM certificates in us-east-1
# due to a CloudFront limitation. Therefore, we need to make a specific
# provider just for this to ensure ACM lookups always happen in us-east-1.
provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

# IAM
data "aws_iam_policy_document" "api_gateway_invoker" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_invoke" {
  statement {
    actions = [
      "logs:*",
      "lambda:InvokeFunction",
    ]

    resources = ["*"]
  }
}

# Create role for API Gateway to use to invoke Lambda
resource "aws_iam_role" "api_gateway_invoker" {
  name               = "${var.stage}_${var.name}_APIGatewayInvoker"
  assume_role_policy = data.aws_iam_policy_document.api_gateway_invoker.json
}

# Attach Lambda invoke policy to API Gateway Role
resource "aws_iam_role_policy" "lambda_invoke_policy" {
  name   = "${var.stage}_${var.name}_lambda_invoke"
  role   = aws_iam_role.api_gateway_invoker.id
  policy = data.aws_iam_policy_document.lambda_invoke.json
}

data "template_file" "swagger_file" {
  template = var.swagger_template

  vars = {
    authorizer_type            = var.authorizer_type
    authorizer_arn             = var.authorizer_arn
    authorizer_header          = var.authorizer_header
    authorizer_role            = aws_iam_role.api_gateway_invoker.arn
    authorizer_expression      = var.authorizer_expression
    authorizer_identity_source = var.authorizer_identity_source
    authorizer_ttl             = var.authorizer_ttl
    lambda_arn                 = var.lambda_arn
    lambda_role                = aws_iam_role.api_gateway_invoker.arn
    stage                      = var.stage != "prod" ? format("%s-", var.stage) : ""
    api_name                   = "${var.stage}_${var.name}"
    description                = "${var.description} (stage: ${var.stage})"
  }
}

resource "aws_api_gateway_rest_api" "api" {
  name               = "${var.stage}_${var.name}"
  body               = data.template_file.swagger_file.rendered
  description        = "${var.description} (stage: ${var.stage})"
  binary_media_types = var.binary_media_types
}

resource "aws_api_gateway_deployment" "stage" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = var.stage

  variables = {
    "version" = md5(data.template_file.swagger_file.rendered)
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_acm_certificate" "ssl_cert" {
  count = var.enable_custom_domain ? 1 : 0

  provider    = aws.us-east-1 # Set the us-east-1 provider from above.
  domain      = var.ssl_domain
  statuses    = ["ISSUED"]
  most_recent = true
}

resource "aws_api_gateway_domain_name" "domain" {
  count           = var.enable_custom_domain ? 1 : 0
  domain_name     = lower(var.custom_domain)
  certificate_arn = data.aws_acm_certificate.ssl_cert[0].arn
}

resource "aws_api_gateway_base_path_mapping" "basepath" {
  count = var.enable_custom_domain ? 1 : 0

  api_id      = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_deployment.stage.stage_name
  domain_name = aws_api_gateway_domain_name.domain[0].domain_name
  base_path   = var.base_path
}

data "aws_route53_zone" "domain" {
  count = var.enable_custom_domain ? 1 : 0
  name  = var.zone_name
}

resource "aws_route53_record" "custom_domain_record" {
  count   = var.enable_custom_domain ? 1 : 0
  zone_id = data.aws_route53_zone.domain[0].zone_id
  name    = lower(var.custom_domain)
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.domain[0].cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.domain[0].cloudfront_zone_id
    evaluate_target_health = false # You cannot set this to true for Cloudfront targets.
  }
}

resource "aws_cloudwatch_metric_alarm" "api_5XX" {
  alarm_name                = "${var.stage}_${var.name}_5XX"
  count                     = var.enable_monitoring ? 1 : 0 # Only create on certain stages.
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "5XXError"
  namespace                 = "AWS/ApiGateway"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "2"
  alarm_description         = "${var.stage} ${var.name} 5XX Errors"
  insufficient_data_actions = []

  dimensions = {
    ApiName = "${var.stage}_${var.name}"
    Stage   = var.stage
  }

  alarm_actions = var.alarm_actions
}

resource "aws_cloudwatch_metric_alarm" "api_4XX" {
  alarm_name                = "${var.stage}_${var.name}_4XX"
  count                     = var.enable_monitoring ? 1 : 0 # Only create on certain stages.
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "4XXError"
  namespace                 = "AWS/ApiGateway"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "10"
  alarm_description         = "${var.stage} ${var.name} 4XX Errors"
  insufficient_data_actions = []

  dimensions = {
    ApiName = "${var.stage}_${var.name}"
    Stage   = var.stage
  }

  alarm_actions = var.alarm_actions
}


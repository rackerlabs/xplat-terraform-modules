resource "aws_cloudwatch_event_rule" "event_rule" {
  count = var.trigger_enabled ? 1 : 0

  name                = var.event_name
  description         = var.event_description
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "schedule_to_lambda" {
  count = var.trigger_enabled ? 1 : 0

  rule      = aws_cloudwatch_event_rule.event_rule[0].name
  target_id = "${aws_cloudwatch_event_rule.event_rule[0].name}_target"
  arn       = var.lambda_arn
  input     = var.target_input
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  count = var.trigger_enabled ? 1 : 0

  statement_id_prefix = "AllowExecutionFromCloudWatch"
  action              = "lambda:InvokeFunction"
  function_name       = var.lambda_arn
  principal           = "events.amazonaws.com"
  source_arn          = aws_cloudwatch_event_rule.event_rule[0].arn
}


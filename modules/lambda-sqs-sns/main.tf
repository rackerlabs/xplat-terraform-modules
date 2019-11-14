# # Set up SQS --------------------------------------------------------------

# SQS dead letter queue
resource "aws_sqs_queue" "dead_letter_queue" {
  name                       = "${var.stage}_${var.name}_dead_letter_queue"
  visibility_timeout_seconds = var.dlq_visibility_timeout_seconds

  tags = {
    stage   = var.stage
    service = var.name
  }
}

# The actual queue the Lambda will listen to
resource "aws_sqs_queue" "queue" {
  name           = "${var.stage}_${var.name}_queue"
  redrive_policy = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.dead_letter_queue.arn}\",\"maxReceiveCount\":${var.max_receive_count}}"

  visibility_timeout_seconds = var.visibility_timeout_seconds

  tags = {
    stage   = var.stage
    service = var.name
  }
}

# Give permissions to SNS to send to SQS
data "aws_iam_policy_document" "sqs_write_policy" {
  statement {
    sid = "AllowLocalWrites"

    actions = [
      "sqs:SendMessage",
    ]

    resources = [aws_sqs_queue.queue.arn]

    principals {
      identifiers = ["sns.amazonaws.com"]
      type        = "Service"
    }
  }

  statement {
    sid = "AllowSNSWrites"

    actions = [
      "sqs:SendMessage",
    ]

    resources = [aws_sqs_queue.queue.arn]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    condition {
      test     = "ArnEquals"
      values   = [var.sns_arn]
      variable = "aws:SourceArn"
    }
  }
}

resource "aws_sqs_queue_policy" "queue_policy" {
  policy    = data.aws_iam_policy_document.sqs_write_policy.json
  queue_url = aws_sqs_queue.queue.id
}

# hook up SNS --> SQS
resource "aws_sns_topic_subscription" "sns_to_sqs" {
  topic_arn     = var.sns_arn
  protocol      = "sqs"
  endpoint      = aws_sqs_queue.queue.arn
  filter_policy = var.filter_policy
}

# hook up SQS to the Lambda
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  batch_size       = var.batch_size
  event_source_arn = aws_sqs_queue.queue.arn
  enabled          = var.trigger_enabled
  function_name    = var.lambda_arn
}

# CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "dlq_queue_size" {
  count = var.enable_monitoring ? 1 : 0 # Only create on certain stages.

  alarm_description   = "${var.stage}_${var.name} Dead Letter Queue size"
  alarm_name          = "${var.stage}_${var.name}_dead_letter_queue_size"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  period              = "120"
  evaluation_periods  = "1"
  datapoints_to_alarm = "1"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName = aws_sqs_queue.dead_letter_queue.name
  }

  alarm_actions             = var.alarm_actions
  insufficient_data_actions = []
  ok_actions                = var.ok_actions
}


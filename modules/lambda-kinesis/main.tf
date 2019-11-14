data "aws_iam_policy_document" "kinesis_policy_document" {
  statement {
    actions = "${var.kinesis_actions}"

    resources = [
      "${var.kinesis_arn}",
    ]
  }
}

resource "aws_iam_role_policy" "lambda_kinesis_policy" {
  name   = "${var.iam_role_name}"
  role   = "${var.lambda_role_name}"
  policy = "${data.aws_iam_policy_document.kinesis_policy_document.json}"
}

resource "aws_lambda_event_source_mapping" "kinesis_to_lambda_mapping" {
  event_source_arn  = "${var.kinesis_arn}"
  function_name     = "${var.lambda_arn}"
  starting_position = "${var.stream_starting_position}"
}

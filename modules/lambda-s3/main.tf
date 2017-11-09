# Subscribe Lambda function to S3 object creation
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${var.s3_arn}"
}

# Additional policy to allow S3 access from Lambda
data "aws_iam_policy_document" "lambda_s3_policy" {
  statement {
    actions = "${var.s3_policy_actions}"

    resources = [
      "${var.s3_arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "hello_lambda_s3_policy" {
  name   = "${var.lambda_s3_policy_name}"
  role   = "${var.lambda_role_name}"
  policy = "${data.aws_iam_policy_document.lambda_s3_policy.json}"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  # Derive bucket name from the arn
  bucket = "${element(split(":", var.s3_arn), 5)}"

  lambda_function {
    lambda_function_arn = "${var.lambda_arn}"
    events              = "${var.s3_events}"
  }
}

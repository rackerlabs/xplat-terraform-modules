variable "lambda_arn" {}
variable "lambda_role_name" {}
variable "lambda_s3_policy_name" {}
variable "s3_arn" {}

# Actions that the Lambda function should be able to take against the S3 bucket
variable "s3_policy_actions" {
  type    = "list"
  default = ["s3:GetObject"]
}

# S3 events to trigger the Lambda function for
variable "s3_events" {
  type    = "list"
  default = ["s3:ObjectCreated:*"]
}

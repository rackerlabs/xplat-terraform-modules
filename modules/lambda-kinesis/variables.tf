variable "lambda_arn" {}
variable "lambda_role_name" {}
variable "kinesis_arn" {}

variable "iam_role_name" {
  default = "iam_for_lambda_with_kinesis"
}

variable "stream_starting_position" {
  default = "TRIM_HORIZON"
}

variable "kinesis_actions" {
  type = "list"

  default = [
    "kinesis:DescribeStream",
    "kinesis:GetShardIterator",
    "kinesis:GetRecords",
    "kinesis:ListStreams",
    "kinesis:PutRecords",
  ]
}

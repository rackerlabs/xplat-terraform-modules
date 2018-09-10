# What is this called
variable "name" {}

variable "stage" {}

# Incoming Lambda to hook up to SQS, which itself will be hooked up to SNS
variable "lambda_arn" {}

# An SNS topic
variable "sns_arn" {}

# Timeout for messages in queue
variable "visibility_timeout_seconds" {
  default = 120
}

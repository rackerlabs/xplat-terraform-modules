# What is this called
variable "name" {}

variable "stage" {}

# Incoming Lambda to hook up to SQS, which itself will be hooked up to SNS
variable "lambda_arn" {}

# An SNS topic
variable "sns_arn" {}

# Timeout for messages in the main queue
variable "visibility_timeout_seconds" {
  default = 120
}

# Timeout for messages in the dead-letter queue
variable "dlq_visibility_timeout_seconds" {
  default = 120
}

variable "enable_monitoring" {
  type    = "string"
  default = 0
}

# List of SNS topic ARNs and/or email addresses
variable "alarm_actions" {
  type    = "list"
  default = []
}

# If you want the alerts to auto-clear, use this as well
variable "ok_actions" {
  type    = "list"
  default = []
}

variable "filter_policy" {
  type    = "string"
  default = ""
}

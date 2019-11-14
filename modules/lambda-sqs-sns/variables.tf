# What is this called
variable "name" {
}

variable "stage" {
}

# Incoming Lambda to hook up to SQS, which itself will be hooked up to SNS
variable "lambda_arn" {
}

# An SNS topic
variable "sns_arn" {
}

# Timeout for messages in the main queue
variable "visibility_timeout_seconds" {
  default = 120
}

# Timeout for messages in the dead-letter queue
variable "dlq_visibility_timeout_seconds" {
  default = 120
}

variable "enable_monitoring" {
  type    = bool
  default = false
}

# List of SNS topic ARNs and/or email addresses
variable "alarm_actions" {
  type    = list(string)
  default = []
}

# If you want the alerts to auto-clear, use this as well
variable "ok_actions" {
  type    = list(string)
  default = []
}

variable "filter_policy" {
  type    = string
  default = ""
}

variable "max_receive_count" {
  type    = string
  default = 4
}

variable "trigger_enabled" {
  type    = string
  default = true
}

variable "batch_size" {
  type    = string
  default = 5
}


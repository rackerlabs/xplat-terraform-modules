variable "trigger_enabled" {
  type    = "string"
  default = "0"
}

variable "event_name" {
  type = "string"
}

variable "event_description" {
  type = "string"
}

variable "target_input" {
  type    = "string"
  default = "{}"
}

variable "schedule_expression" {
  type = "string"
}

variable "lambda_arn" {
  type = "string"
}

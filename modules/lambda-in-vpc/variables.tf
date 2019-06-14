variable "alarm_actions" {
  type    = "list"
  default = []
}

variable "ok_actions" {
  type    = "list"
  default = []
}

variable "enable_monitoring" {
  type    = "string"
  default = 0
}

variable "env_variables" {
  type    = "map"
  default = {}
}

variable "file" {}

variable "handler" {
  type    = "string"
  default = "handler.lambda_handler"
}

variable "memory_size" {
  type    = "string"
  default = 256
}

variable "name" {}

variable "publish" {
  type    = "string"
  default = true
}

variable "stage" {}

variable "runtime" {
  type    = "string"
  default = "python3.6"
}

variable "timeout" {
  type    = "string"
  default = 60
}

variable "description" {
  type    = "string"
  default = ""
}

variable "subnet_ids" {
  type    = "list"
  default = []
}

variable "security_group_ids" {
  type    = "list"
  default = []
}

variable "kms_key_arn" {
  type    = "string"
  default = ""
}

variable "tracing_mode" {
  type    = "string"
  default = "PassThrough"
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "reserved_concurrent_executions" {
  type    = "string"
  default = "-1"
}

variable "throttle_threshold" {
  type    = "string"
  default = "1"
}

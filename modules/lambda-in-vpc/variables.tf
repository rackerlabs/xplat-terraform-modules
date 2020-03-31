variable "alarm_actions" {
  type    = list(string)
  default = []
}

variable "ok_actions" {
  type    = list(string)
  default = []
}

variable "enable_monitoring" {
  type    = bool
  default = false
}

variable "env_variables" {
  type    = map(string)
  default = {}
}

variable "file" {
  type    = string
  default = null
}

variable "handler" {
  type    = string
  default = "handler.lambda_handler"
}

variable "memory_size" {
  type    = string
  default = 256
}

variable "name" {}

variable "publish" {
  type    = bool
  default = true
}

variable "stage" {
  type = string
}

variable "runtime" {
  type    = string
  default = "python3.6"
}

variable "timeout" {
  type    = string
  default = 60
}

variable "description" {
  type    = string
  default = ""
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "kms_key_arn" {
  type    = string
  default = ""
}

variable "tracing_mode" {
  type    = string
  default = "PassThrough"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "reserved_concurrent_executions" {
  type    = string
  default = "-1"
}

variable "throttle_threshold" {
  type    = string
  default = "1"
}

variable "layers" {
  type    = list(string)
  default = []
}

variable "source_code_hash" {
  type    = string
  default = null
}

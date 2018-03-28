variable "alarm_actions" {
  type    = "list"
  default = []
}

variable "authorizer_arn" {
  type    = "string"
  default = ""
}

variable "authorizer_header" {
  type    = "string"
  default = ""
}

variable "authorizer_expression" {
  type    = "string"
  default = ""
}

variable "authorizer_identity_source" {
  type    = "string"
  default = ""
}

variable "authorizer_ttl" {
  type    = "string"
  default = ""
}

variable "authorizer_type" {
  type    = "string"
  default = "token"
}

variable "base_path" {
  type    = "string"
  default = ""
}

variable "custom_domain" {
  type    = "string"
  default = ""
}

variable "enable_custom_domain" {
  type    = "string"
  default = 0
}

variable "enable_monitoring" {
  type    = "string"
  default = 0
}

variable "lambda_arn" {
  type    = "string"
  default = ""
}

variable "name" {}

variable "ssl_domain" {
  type    = "string"
  default = ""
}

variable "stage" {}
variable "swagger_template" {}

variable "zone_name" {
  type    = "string"
  default = ""
}

variable "description" {
  type    = "string"
  default = ""
}

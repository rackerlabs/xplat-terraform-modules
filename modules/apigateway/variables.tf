variable "alarm_actions" {
  type    = list(string)
  default = []
}

variable "authorizer_arn" {
  type    = string
  default = ""
}

variable "authorizer_header" {
  type    = string
  default = ""
}

variable "authorizer_expression" {
  type    = string
  default = ""
}

variable "authorizer_identity_source" {
  type    = string
  default = ""
}

variable "authorizer_ttl" {
  type    = string
  default = ""
}

variable "authorizer_type" {
  type    = string
  default = "token"
}

variable "base_path" {
  type    = string
  default = ""
}

variable "custom_domain" {
  type    = string
  default = ""
}

variable "enable_custom_domain" {
  type    = bool
  default = false
}

variable "enable_monitoring" {
  type    = bool
  default = false
}

variable "lambda_arn" {
  type    = string
  default = ""
}

variable "name" {
}

variable "ssl_domain" {
  type    = string
  default = ""
}

variable "stage" {
}

variable "swagger_template" {
}

variable "zone_name" {
  type    = string
  default = ""
}

variable "description" {
  type    = string
  default = ""
}

variable "binary_media_types" {
  type    = list(string)
  default = []
}


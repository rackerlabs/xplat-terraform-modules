data "aws_caller_identity" "current" {}

variable "lambda_role" {}
variable "key_alias" {}

variable "key_autorotate" {
    default = true
}

variable "admin_can_decrypt" {
    default = false
}

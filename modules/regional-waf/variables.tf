variable "stage" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = ""
}

variable "acl_association_resource_arn" {
  type    = string
  default = ""
}

variable "api_name" {
  type    = string
  default = ""
}

# Valid values are BLOCK or ALLOW
# The correct setting is almost always ALLOW.
variable "web_acl_default_action" {
  type    = string
  default = "ALLOW"
}

# Valid values are BLOCK, ALLOW, COUNT.
# BLOCK will typically be the correct production value.
# The default value is set to COUNT so that a rule action of BLOCK or ALLOW
# is an intentional decision.

variable "ip_blacklist_default_action" {
  type    = string
  default = "COUNT"
}

variable "rate_ip_throttle_default_action" {
  type    = string
  default = "COUNT"
}

variable "xss_match_rule_default_action" {
  type    = string
  default = "COUNT"
}

variable "byte_match_traversal_default_action" {
  type    = string
  default = "COUNT"
}

variable "byte_match_webroot_default_action" {
  type    = string
  default = "COUNT"
}

variable "sql_injection_default_action" {
  type    = string
  default = "COUNT"
}

# rate throttle IP Range(s)
# Must be in CIDR format
variable "iplist_throttle_CIDR_0" {
  type    = string
  default = "0.0.0.0/32"
}

# Requests per 5 Minutes.
variable "rate_ip_throttle_limit" {
  type    = string
  default = 5000
}

# Because COUNT still does not exist for modules.
# This enables us to selectively deploy this resource to
# only to certain stages, ie.  test, vs dev, vs prod.
# As of this PR there are still some very low per account
# resource limits for rate based rules.
# https://docs.aws.amazon.com/waf/latest/developerguide/limits.html
# This is problematic in cases where you have test accounts with multiple projects
# and multiple developers each running named instances that use this module.

variable "enabled" {
  type    = bool
  default = false
}


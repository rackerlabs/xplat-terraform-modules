/*
 * Module: xplat-ui-deploy
 */

variable "bucket_name" {
  description = "The name of the bucket we're putting the ui in."
}

variable "dist_path" {
  description = "The location of the ui directory to sync with s3."
}

variable "domain" {
  description = "The domain that the ui will be available at (without protocol)."
}

variable "region" {
  default     = "us-east-1"
  description = "The region to deploy the ui to."
}

variable "service_name" {
  description = "The ui that's being deployed."
}

variable "stage" {
  description = "The stage of the ui build."
}

variable "routing_rules_template_path" {
  description = "The file path to the routing rules template."
}

/*
 * Module: xplat-ui-deploy
 *
 * This template creates the following resources
 *   - aws_s3_bucket
 *
 */

# This module uses conditionals and therefore needs at least 0.8.0
# https://github.com/hashicorp/terraform/blob/master/CHANGELOG.md#080-december-13-2016

terraform {
  required_version = ">= 0.8.0"
}

data "template_file" "host_name" {
  template = "$${isProduction ? domain : format("%s.%s", stage, domain)}"

  vars {
    isProduction = "${var.stage == "prod"}"
    stage        = "${var.stage}"
    domain       = "${var.domain}"
  }
}

data "template_file" "ui_policy" {
  template = "${file("${path.module}/templates/ui-policy.tpl")}"

  vars {
    bucket_name = "${var.bucket_name}"
  }
}

data "template_file" "ui_routing_rules" {
  template = "${file("${path.module}/templates/ui-routing-rules.tpl")}"

  vars {
    host_name = "${data.template_file.host_name.rendered}"
  }
}

resource "aws_s3_bucket" "ui" {
  acl           = "public-read"
  bucket        = "${var.bucket_name}"
  force_destroy = true
  policy        = "${data.template_file.ui_policy.rendered}"

  tags {
    ServiceName = "${var.service_name}"
    Environment = "${var.stage}"
  }

  website {
    index_document = "index.html"
    error_document = "index.html"
    routing_rules  = "${data.template_file.ui_routing_rules.rendered}"
  }
}

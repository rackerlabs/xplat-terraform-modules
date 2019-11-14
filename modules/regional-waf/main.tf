provider "aws" {
  region = var.region
}

# for a WAF we specify the conditions -> assign the descriptor to a aws_waf_rule -> assign the rule to a aws_waf_web_acl.
# a aws_waf_web_acl can contain many rules.
# a aws_waf_rule can be utilized by more than one aws_waf_web_acl.

# Conditions
# Mostly taken from https://s3.us-east-2.amazonaws.com/awswaf-owasp/owasp_10_base.yml

resource "aws_wafregional_ipset" "iplist_throttle" {
  name = "${var.stage}_${var.region}_${var.api_name}_iplist_throttle"

  count = var.enabled ? 1 : 0

  ip_set_descriptor {
    type  = "IPV4"
    value = var.iplist_throttle_CIDR_0
  }
}

## 10.
## Generic
## IP Blacklist
## Matches IP addresses that should not be allowed to access content

resource "aws_wafregional_ipset" "iplist_blacklist" {
  name = "${var.stage}_${var.region}_${var.api_name}_iplist_blacklist"

  count = var.enabled ? 1 : 0
  # RULE in place. Use UI in an emergency to add new IP sets. Clean up terraform if IP block becomes
  # permanent.
  #ip_set_descriptor {
  #    type = "IPV4"
  #    value = ""
  #}
}

## OWASP Top 10 A3
## Mitigate Cross Site Scripting Attacks
## Matches attempted XSS patterns in the URI, QUERY_STRING, BODY, COOKIES
resource "aws_wafregional_xss_match_set" "xss_match_conditions" {
  name = "${var.stage}_${var.region}_${var.api_name}_xss_match_conditions"

  count = var.enabled ? 1 : 0

  xss_match_tuple {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "URI"
    }
  }

  xss_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "URI"
    }
  }

  xss_match_tuple {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  xss_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  xss_match_tuple {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "BODY"
    }
  }

  xss_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "BODY"
    }
  }

  xss_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "HEADER"
      data = "cookie"
    }
  }

  xss_match_tuple {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "HEADER"
      data = "cookie"
    }
  }
}

## OWASP Top 10 A1
## Mitigate SQL Injection Attacks
## Matches attempted SQLi patterns in the URI, QUERY_STRING, BODY, COOKIES
resource "aws_wafregional_sql_injection_match_set" "sql_injection_match_set" {
  name = "${var.stage}_${var.region}_${var.api_name}_sql_injection_match_set"

  count = var.enabled ? 1 : 0

  sql_injection_match_tuple {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "URI"
    }
  }

  sql_injection_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "URI"
    }
  }

  sql_injection_match_tuple {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  sql_injection_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  sql_injection_match_tuple {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "BODY"
    }
  }

  sql_injection_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "BODY"
    }
  }

  sql_injection_match_tuple {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "HEADER"
      data = "cookie"
    }
  }

  sql_injection_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "HEADER"
      data = "cookie"
    }
  }
}

## OWASP Top 10 A4
## Path Traversal, LFI, RFI
## Matches request patterns designed to traverse filesystem paths, and include
## local or remote files

resource "aws_wafregional_byte_match_set" "byte_set_traversal" {
  name = "${var.stage}_${var.region}_${var.api_name}__byte_match_set"

  count = var.enabled ? 1 : 0

  byte_match_tuples {
    text_transformation   = "URL_DECODE"
    target_string         = "../"
    positional_constraint = "CONTAINS"

    field_to_match {
      type = "URI"
    }
  }

  byte_match_tuples {
    text_transformation   = "HTML_ENTITY_DECODE"
    target_string         = "../"
    positional_constraint = "CONTAINS"

    field_to_match {
      type = "URI"
    }
  }

  byte_match_tuples {
    text_transformation   = "URL_DECODE"
    target_string         = "../"
    positional_constraint = "CONTAINS"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  byte_match_tuples {
    text_transformation   = "HTML_ENTITY_DECODE"
    target_string         = "../"
    positional_constraint = "CONTAINS"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  byte_match_tuples {
    text_transformation   = "URL_DECODE"
    target_string         = "://"
    positional_constraint = "CONTAINS"

    field_to_match {
      type = "URI"
    }
  }

  byte_match_tuples {
    text_transformation   = "HTML_ENTITY_DECODE"
    target_string         = "://"
    positional_constraint = "CONTAINS"

    field_to_match {
      type = "URI"
    }
  }

  byte_match_tuples {
    text_transformation   = "URL_DECODE"
    target_string         = "://"
    positional_constraint = "CONTAINS"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  byte_match_tuples {
    text_transformation   = "HTML_ENTITY_DECODE"
    target_string         = "://"
    positional_constraint = "CONTAINS"

    field_to_match {
      type = "QUERY_STRING"
    }
  }
}

## 9.
## OWASP Top 10 A9
## Server-side includes & libraries in webroot
## Matches request patterns for webroot objects that shouldn't be directly accessible
resource "aws_wafregional_byte_match_set" "byte_set_webroot_requests" {
  name = "${var.stage}_${var.region}_${var.api_name}__byte_match_webroot_requests"

  count = var.enabled ? 1 : 0

  byte_match_tuples {
    text_transformation   = "LOWERCASE"
    target_string         = ".cfg"
    positional_constraint = "ENDS_WITH"

    field_to_match {
      type = "URI"
    }
  }

  byte_match_tuples {
    text_transformation   = "LOWERCASE"
    target_string         = ".conf"
    positional_constraint = "ENDS_WITH"

    field_to_match {
      type = "URI"
    }
  }

  byte_match_tuples {
    text_transformation   = "LOWERCASE"
    target_string         = ".config"
    positional_constraint = "ENDS_WITH"

    field_to_match {
      type = "URI"
    }
  }

  byte_match_tuples {
    text_transformation   = "LOWERCASE"
    target_string         = ".ini"
    positional_constraint = "ENDS_WITH"

    field_to_match {
      type = "URI"
    }
  }

  byte_match_tuples {
    text_transformation   = "LOWERCASE"
    target_string         = ".log"
    positional_constraint = "ENDS_WITH"

    field_to_match {
      type = "URI"
    }
  }

  byte_match_tuples {
    text_transformation   = "LOWERCASE"
    target_string         = ".bak"
    positional_constraint = "ENDS_WITH"

    field_to_match {
      type = "URI"
    }
  }

  byte_match_tuples {
    text_transformation   = "LOWERCASE"
    target_string         = ".backup"
    positional_constraint = "ENDS_WITH"

    field_to_match {
      type = "URI"
    }
  }

  byte_match_tuples {
    text_transformation   = "URL_DECODE"
    target_string         = "/includes"
    positional_constraint = "STARTS_WITH"

    field_to_match {
      type = "URI"
    }
  }

  byte_match_tuples {
    text_transformation   = "URL_DECODE"
    target_string         = "/admin"
    positional_constraint = "STARTS_WITH"

    field_to_match {
      type = "URI"
    }
  }
}

# Rules

## 10.
## Generic
## IP Blacklist
## Matches IP addresses that should not be allowed to access content

resource "aws_wafregional_rule" "ip_blacklist" {
  name = "${var.stage}_${var.region}_${var.api_name}_ip_blacklist"

  # metric_name is alpha numeric only.
  metric_name = "${replace(var.stage, "/[^a-zA-Z0-9]/", "")}${replace(var.region, "/[^a-zA-Z0-9]/", "")}${replace(var.api_name, "/[^a-zA-Z0-9]/", "")}ipblacklist"

  predicate {
    type    = "IPMatch"
    data_id = aws_wafregional_ipset.iplist_blacklist[0].id
    negated = false
  }

  count = var.enabled ? 1 : 0
}

resource "aws_wafregional_rate_based_rule" "rate_ip_throttle" {
  name = "${var.stage}_${var.region}_${var.api_name}_ip_throttle"

  # metric_name is alpha numeric only.
  metric_name = "${replace(var.stage, "/[^a-zA-Z0-9]/", "")}${replace(var.region, "/[^a-zA-Z0-9]/", "")}${replace(var.api_name, "/[^a-zA-Z0-9]/", "")}ipthrottle"

  rate_key   = "IP"
  rate_limit = var.rate_ip_throttle_limit

  predicate {
    type    = "IPMatch"
    data_id = aws_wafregional_ipset.iplist_throttle[0].id
    negated = false
  }

  depends_on = [aws_wafregional_ipset.iplist_throttle]

  count = var.enabled ? 1 : 0
}

## OWASP Top 10 A3
## Mitigate Cross Site Scripting Attacks
## Matches attempted XSS patterns in the URI, QUERY_STRING, BODY, COOKIES
resource "aws_wafregional_rule" "xss_match_rule" {
  name = "${var.stage}_${var.region}_${var.api_name}_xss_match_rule"

  # metric_name is alpha numeric only.
  metric_name = "${replace(var.stage, "/[^a-zA-Z0-9]/", "")}${replace(var.region, "/[^a-zA-Z0-9]/", "")}${replace(var.api_name, "/[^a-zA-Z0-9]/", "")}xssmatchrule"

  predicate {
    type    = "XssMatch"
    data_id = aws_wafregional_xss_match_set.xss_match_conditions[0].id
    negated = false
  }

  depends_on = [aws_wafregional_xss_match_set.xss_match_conditions]

  count = var.enabled ? 1 : 0
}

# OWASP Top 10 A1
## Mitigate SQL Injection Attacks
## Matches attempted SQLi patterns in the URI, QUERY_STRING, BODY, COOKIES

resource "aws_wafregional_rule" "sql_injection_rule" {
  name = "${var.stage}_${var.region}_${var.api_name}_sql_injection_rule"

  # metric_name is alpha numeric only.
  metric_name = "${replace(var.stage, "/[^a-zA-Z0-9]/", "")}${replace(var.region, "/[^a-zA-Z0-9]/", "")}${replace(var.api_name, "/[^a-zA-Z0-9]/", "")}sqlinjectionrule"

  predicate {
    type    = "SqlInjectionMatch"
    data_id = aws_wafregional_sql_injection_match_set.sql_injection_match_set[0].id
    negated = false
  }

  depends_on = [aws_wafregional_sql_injection_match_set.sql_injection_match_set]

  count = var.enabled ? 1 : 0
}

## OWASP Top 10 A4
## Path Traversal, LFI, RFI
## Matches request patterns designed to traverse filesystem paths, and include
## local or remote files

resource "aws_wafregional_rule" "byte_match_traversal" {
  name = "${var.stage}_${var.region}_${var.api_name}_byte_match_traversal"

  # metric_name is alpha numeric only.
  metric_name = "${replace(var.stage, "/[^a-zA-Z0-9]/", "")}${replace(var.region, "/[^a-zA-Z0-9]/", "")}${replace(var.api_name, "/[^a-zA-Z0-9]/", "")}bytematchtraversalrule"

  predicate {
    type    = "ByteMatch"
    data_id = aws_wafregional_byte_match_set.byte_set_traversal[0].id
    negated = false
  }

  depends_on = [aws_wafregional_byte_match_set.byte_set_traversal]

  count = var.enabled ? 1 : 0
}

## 9.
## OWASP Top 10 A9
## Server-side includes & libraries in webroot
## Matches request patterns for webroot objects that shouldn't be directly accessible
resource "aws_wafregional_rule" "byte_match_webroot" {
  name = "${var.stage}_${var.region}_${var.api_name}_byte_match_webroot"

  # metric_name is alpha numeric only.
  metric_name = "${replace(var.stage, "/[^a-zA-Z0-9]/", "")}${replace(var.region, "/[^a-zA-Z0-9]/", "")}${replace(var.api_name, "/[^a-zA-Z0-9]/", "")}bytematchwebrootrule"

  predicate {
    type    = "ByteMatch"
    data_id = aws_wafregional_byte_match_set.byte_set_webroot_requests[0].id
    negated = false
  }

  depends_on = [aws_wafregional_byte_match_set.byte_set_webroot_requests]

  count = var.enabled ? 1 : 0
}

# Web ACLs
resource "aws_wafregional_web_acl" "rms_web_acl" {
  name = "${var.stage}_${var.region}_${var.api_name}_rms_web_acl"

  # metric_name is alpha numeric only.
  metric_name = "${replace(var.stage, "/[^a-zA-Z0-9]/", "")}${replace(var.region, "/[^a-zA-Z0-9]/", "")}${replace(var.api_name, "/[^a-zA-Z0-9]/", "")}rmswebacl"
  depends_on = [
    aws_wafregional_rate_based_rule.rate_ip_throttle,
    aws_wafregional_rule.ip_blacklist,
    aws_wafregional_rule.byte_match_traversal,
    aws_wafregional_rule.xss_match_rule,
    aws_wafregional_rule.byte_match_webroot,
    aws_wafregional_rule.sql_injection_rule,
  ]

  default_action {
    type = var.web_acl_default_action
  }

  count = var.enabled ? 1 : 0

  rule {
    action {
      type = var.ip_blacklist_default_action
    }
    priority = 10
    rule_id  = aws_wafregional_rule.ip_blacklist[0].id
    type     = "REGULAR"
  }
  rule {
    action {
      type = var.rate_ip_throttle_default_action
    }
    priority = 20
    rule_id  = aws_wafregional_rate_based_rule.rate_ip_throttle[0].id

    # Must be RATE_BASED, GROUP or REGULAR
    # If you fail to declare this, the rule will not be applied to the ACL.
    # https://docs.aws.amazon.com/waf/latest/APIReference/API_regional_UpdateWebACL.html
    type = "RATE_BASED"
  }
  rule {
    action {
      type = var.xss_match_rule_default_action
    }
    priority = 30
    rule_id  = aws_wafregional_rule.xss_match_rule[0].id
    type     = "REGULAR"
  }

  rule {
    action {
      type = var.byte_match_traversal_default_action
    }
    priority = 40
    rule_id  = aws_wafregional_rule.byte_match_traversal[0].id
    type     = "REGULAR"
  }

  rule {
    action {
      type = var.byte_match_webroot_default_action
    }
    priority = 50
    rule_id  = aws_wafregional_rule.byte_match_webroot[0].id
    type     = "REGULAR"
  }

  rule {
    action {
      type = var.sql_injection_default_action
    }
    priority = 60
    rule_id  = aws_wafregional_rule.sql_injection_rule[0].id
    type     = "REGULAR"
  }
}

resource "aws_wafregional_web_acl_association" "web_acl_association" {
  resource_arn = var.acl_association_resource_arn
  web_acl_id   = aws_wafregional_web_acl.rms_web_acl[0].id
  count        = var.enabled ? 1 : 0
}


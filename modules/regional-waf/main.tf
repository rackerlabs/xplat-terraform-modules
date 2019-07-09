# Configure the remote-state backend.


terraform { 
    backend "s3" {
        encrypt = "true"
        acl = "private"
    }
}

locals {
    production = "${var.stage == "prod"}"
}

provider "aws" {
  region = "${var.region}"
}
data "aws_caller_identity" "current" {}

output "aws_account_id" {
    value = "${data.aws_caller_identity.current.account_id}"
}

# for a WAF we specify the conditions -> assign the descriptor to a aws_waf_rule -> assign the rule to a aws_waf_web_acl.
# an aws_waf_web_acl can contain many rules.
# a aws_waf_rule can be utilized by more than one aws_waf_web_acl.

# Conditions
# Mostly taken from https://s3.us-east-2.amazonaws.com/awswaf-owasp/owasp_10_base.yml

resource "aws_wafregional_ipset" "iplist_throttle" {
    name = "${var.stage}_${var.region}_${var.lambda_name}_iplist_throttle"

    ip_set_descriptor {
        type = "IPV4"
        value = "0.0.0.0/32"
    }
}

## 10.
## Generic
## IP Blacklist
## Matches IP addresses that should not be allowed to access content

resource "aws_wafregional_ipset" "iplist_blacklist" {
    name = "${var.stage}_${var.region}_${var.lambda_name}_iplist_blacklist"

#    ip_set_descriptor {
#        type = "IPV4"
#        value = "0.0.0.0/32"
#    }

}



## OWASP Top 10 A3
## Mitigate Cross Site Scripting Attacks
## Matches attempted XSS patterns in the URI, QUERY_STRING, BODY, COOKIES
resource "aws_wafregional_xss_match_set" "xss_match_conditions" {
    name = "${var.stage}_${var.region}_${var.lambda_name}_xss_match_conditions"

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
  name = "${var.stage}_${var.region}_${var.lambda_name}_sql_injection_match_set"

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
  name = "${var.stage}_${var.region}_${var.lambda_name}__byte_match_set"

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
    name = "${var.stage}_${var.region}_${var.lambda_name}__byte_match_webroot_requests"

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

    name = "${var.stage}_${var.region}_${var.lambda_name}_ip_blacklist"
    metric_name = "${var.stage}ipblacklist"

    predicate {
        type = "IPMatch"
        data_id = "${aws_wafregional_ipset.iplist_blacklist.id}"
        negated = false
    }
}


resource "aws_wafregional_rate_based_rule" "rate_ip_throttle" {

    name = "${var.stage}_${var.region}_${var.lambda_name}_ip_throttle"
    metric_name = "${var.stage}ipthrottle"

    rate_key = "IP"
    rate_limit = 5000

    predicate {
        type = "IPMatch"
        data_id = "${aws_wafregional_ipset.iplist_throttle.id}"
        negated = false
    }

    depends_on = ["aws_wafregional_ipset.iplist_throttle"]

}

## OWASP Top 10 A3
## Mitigate Cross Site Scripting Attacks
## Matches attempted XSS patterns in the URI, QUERY_STRING, BODY, COOKIES
resource "aws_wafregional_rule" "xss_match_rule" {
    name = "${var.stage}_${var.region}_${var.lambda_name}_xss_match_rule"
    metric_name = "${var.stage}xssmatchrule"

    predicate {
        type = "XssMatch"
        data_id = "${aws_wafregional_xss_match_set.xss_match_conditions.id}"
        negated = false
    }

    depends_on = ["aws_wafregional_xss_match_set.xss_match_conditions"]

}

# OWASP Top 10 A1
## Mitigate SQL Injection Attacks
## Matches attempted SQLi patterns in the URI, QUERY_STRING, BODY, COOKIES

resource "aws_wafregional_rule" "sql_injection_rule" {
    name = "${var.stage}_${var.region}_${var.lambda_name}_sql_injection_rule"
    metric_name = "${var.stage}sqlinjectionrule"

    predicate {
        type = "SqlInjectionMatch"
        data_id = "${aws_wafregional_sql_injection_match_set.sql_injection_match_set.id}"
        negated = false
    }

    depends_on = ["aws_wafregional_sql_injection_match_set.sql_injection_match_set"]
}

## OWASP Top 10 A4
## Path Traversal, LFI, RFI
## Matches request patterns designed to traverse filesystem paths, and include
## local or remote files

resource "aws_wafregional_rule" "byte_match_traversal" {
  
  name = "${var.stage}_${var.region}_${var.lambda_name}_byte_match_traversal"
  metric_name = "${var.stage}bytematchtraversalrule"
  
  predicate {
      type = "ByteMatch"
      data_id = "${aws_wafregional_byte_match_set.byte_set_traversal.id}"
      negated = false
  }

    depends_on = ["aws_wafregional_byte_match_set.byte_set_traversal"]

}

## 9.
## OWASP Top 10 A9
## Server-side includes & libraries in webroot
## Matches request patterns for webroot objects that shouldn't be directly accessible
resource "aws_wafregional_rule" "byte_match_webroot" {
  
  name = "${var.stage}_${var.region}_${var.lambda_name}_byte_match_webroot"
  metric_name = "${var.stage}bytematchwebrootrule"
  
  predicate {
      type = "ByteMatch"
      data_id = "${aws_wafregional_byte_match_set.byte_set_webroot_requests.id}"
      negated = false
  }

    depends_on = ["aws_wafregional_byte_match_set.byte_set_webroot_requests"]

}


# Web ACLs
resource "aws_wafregional_web_acl" "rms_general_wacl" {
    name = "${var.stage}_${var.region}_${var.lambda_name}_rms_general_wacl"
    metric_name = "${var.stage}rmsgeneralwacl"
    depends_on = [
        "aws_wafregional_rate_based_rule.rate_ip_throttle",
        "aws_wafregional_ipset.iplist_throttle",
        "aws_wafregional_rule.ip_blacklist"
    ]

    default_action {
       type = "ALLOW"
        }

    rule {
        action {
            type = "COUNT"
            }
        priority = 10
        rule_id = "${aws_wafregional_rule.ip_blacklist.id}"
        type = "REGULAR"
    }
    rule {
        action {
            type = "COUNT"
            }
        priority = 20
        rule_id = "${aws_wafregional_rate_based_rule.rate_ip_throttle.id}"
        # Must be RATE_BASED, GROUP or REGULAR
        # If you fail to declare this, the rule will not be applied to the ACL.
        # https://docs.aws.amazon.com/waf/latest/APIReference/API_regional_UpdateWebACL.html
        type = "RATE_BASED"
    }
    rule {
        action {
            type = "COUNT"
            }
        priority = 30
        rule_id = "${aws_wafregional_rule.xss_match_rule.id}"
        type = "REGULAR"
    }

        rule {
        action {
            type = "COUNT"
            }
        priority = 40
        rule_id = "${aws_wafregional_rule.byte_match_traversal.id}"
        type = "REGULAR"
    }

        rule {
        action {
            type = "COUNT"
            }
        priority = 50
        rule_id = "${aws_wafregional_rule.byte_match_webroot.id}"
        type = "REGULAR"
    }

        rule {
        action {
            type = "COUNT"
            }
        priority = 60
        rule_id = "${aws_wafregional_rule.sql_injection_rule.id}"
        type = "REGULAR"
    }

}


resource "aws_wafregional_web_acl_association" "web_acl_association" {
    # https://stackoverflow.com/questions/48514180/how-can-i-find-the-arn-of-an-api-gateway-stage
    resource_arn = "${var.api_gateway_arn}"
    web_acl_id = "${aws_wafregional_web_acl.rms_general_wacl.id}"
}
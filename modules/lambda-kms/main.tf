data "aws_iam_policy_document" "kms_policy" {
  statement {
    actions = [
      "kms:*"
    ]

    resources = [
      "*"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        "${data.aws_caller_identity.current.arn}"
      ]
    }
  }

  statement {
    effect = "${var.admin_can_decrypt == "true" ? "Allow" : "Deny"}"

    actions = [
      "Decrypt"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        "${data.aws_caller_identity.current.arn}"
      ]
    }    
  }

  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = [
      "*"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.lambda_role}"
      ]
    }
  }
}

resource "aws_kms_key" "key" {
  enable_key_rotation = "${var.key_autorotate}"
  policy              = "${data.aws_iam_policy_document.kms_policy.json}"
}

resource "aws_kms_alias" "key_alias" {
  name = "alias/${var.key_alias}"
  target_key_id = "${aws_kms_key.key.key_id}"
}

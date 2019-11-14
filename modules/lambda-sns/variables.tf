variable "lambda_arn" {
}

variable "sns_arn" {
}

variable "iam_role_name" {
  default = "iam_for_lambda_with_sns"
}

variable "assume_role_policy" {
  default = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "lambda.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
  }
]
}
EOF

}


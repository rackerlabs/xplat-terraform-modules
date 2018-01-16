output "lambda_role_name" {
  value = "${aws_iam_role.execution_lambda_role.name}"
}

output "lambda_role_arn" {
  value = "${aws_iam_role.execution_lambda_role.arn}"
}

output "lambda_arn" {
  value = "${aws_lambda_function.lambda.arn}"
}

output "lambda_alias_arn" {
  value = "${aws_lambda_alias.lambda_alias.arn}"
}

output "lambda_function_name" {
  value = "${aws_lambda_function.lambda.function_name}"
}

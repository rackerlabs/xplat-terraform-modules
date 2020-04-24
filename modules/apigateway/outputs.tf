output "api_id" {
  value = aws_api_gateway_rest_api.api.id
}

output "api_name" {
  value = aws_api_gateway_rest_api.api.name
}

output "invoke_url" {
  # If we have a custom domain set up, we should point the endpoint to that.
  # Otherwise take the deployment's invoke URL, and strip the intermediary
  # stage suffix from the URL.
  value = var.enable_custom_domain ? format("https://%s", var.custom_domain) : (var.enable_xray ? aws_api_gateway_stage.stage[0].invoke_url : aws_api_gateway_deployment.stage[0].invoke_url)
}

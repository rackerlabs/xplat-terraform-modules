/*
 * Module: xplat-ui-deploy
 *
 * Outputs:
 *   - host_name
 *   - s3_bucket_url
 */

output "host_name" {
  value = "${data.template_file.host_name.rendered}"
}

output "s3_bucket_url" {
  value = "${aws_s3_bucket.ui.website_endpoint}"
}

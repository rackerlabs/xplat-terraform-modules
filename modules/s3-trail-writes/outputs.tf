output "bucket_arn" {
  value = "${aws_s3_bucket.content_bucket.arn}"
}

output "trail" {
  value = "${aws_cloudtrail.bucket_trail.arn}"
}

output "trail_bucket_arn" {
  value = "${aws_s3_bucket.bucket_for_trail.arn}"
}

output "bucket_arn" {
  value = "${aws_s3_bucket.content_bucket.arn}"
}

output "bucket_id" {
  value = "${aws_s3_bucket.content_bucket.id}"
}

output "trail" {
  value = "${aws_cloudtrail.bucket_trail.arn}"
}

output "trail_bucket_arn" {
  value = "${aws_s3_bucket.bucket_for_trail.arn}"
}

output "trail_bucket_id" {
  value = "${aws_s3_bucket.bucket_for_trail.id}"
}

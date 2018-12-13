resource "aws_s3_bucket" "content_bucket" {
  bucket = "${var.bucket_name}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "${var.encryption}"
      }
    }
  }
}

resource "aws_cloudtrail" "bucket_trail" {
  name                          = "${var.bucket_name}-writes"
  s3_bucket_name                = "${aws_s3_bucket.bucket_for_trail.id}"
  include_global_service_events = false

  event_selector {
    read_write_type           = "WriteOnly"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["${aws_s3_bucket.content_bucket.arn}/"]
    }
  }
}

resource "aws_s3_bucket" "bucket_for_trail" {
  bucket        = "${aws_s3_bucket.content_bucket.id}-writes"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.content_bucket.id}-writes"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.content_bucket.id}-writes/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

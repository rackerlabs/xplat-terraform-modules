output "sqs_arn" {
  value = "${aws_sqs_queue.queue.arn}"
}

output "sqs_url" {
  value = "${aws_sqs_queue.queue.id}"
}

output "dlq_arn" {
  value = "${aws_sqs_queue.dead_letter_queue.arn}"
}

output "dlq_url" {
  value = "${aws_sqs_queue.dead_letter_queue.id}"
}

# lambda-sqs-sns

Puts an SQS queue between an SNS topic and a lambda.

Use this if you would otherwise have a lambda consuming from an SNS topic but don't want to risk losing any messages.

The SQS queue will instead consume messages from the SNS topic and then automatically deliver them to the lambda. If the lambda fails to process them, they will be sent to a dead letter queue which is also created by this module.

## Variables

* `sns_arn` - The SNS topic you want to read messages from.

* `lambda_arn` - The lambda you want to direct messages to.

* `name` - Used, along with `stage`, to create the name of the main queue and the dead letter queue. Also used for some tags.

* `stage` - See `name`.

* `enable_monitoring` - Probably want to set this to `1` in a `prod` environment, so that you get alerted when something hits the DLQ.

* `alarm_actions` - List of SNS topic ARNs and/or email addresses where the alarm should be sent to. If you want the alerts to be resolved automatically, you can also set `ok_actions`

* `filter_policy` - Set filter policy on the SNS subscription, meaning only certain messages will be forwarded to the SQS queue (must be JSON).

* `max_receive_count` - How many times a message is allowed to be processed by the Lambda before sending it to the DLQ (default: `4`)

* `trigger_enabled` - The SQS->Lambda trigger can be turned off by setting this to `false` (default: `true`)

* `batch_size` - Maximum number of messages a single Lambda invocation will process (default: `5`)

* `alarm_threshold` - When this number of messages are visible in the DLQ, the alarm will be triggered (default: `1`)

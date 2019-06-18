# lambda-cloudwatch

Sets up a CloudWatch Event that triggers a Lambda function based on a defined schedule. Three AWS resources are created to achieve this:

* CloudWatch Event Rule
* CloudWatch Event Target
* Lambda Permission

## Variables

* `trigger_enabled`: Defines whether the triggers should be put in place. `1` means enabled, `0` is disabled (default: `0`).
* `event_name`: Name of the CloudWatch Event, should be unique within an AWS account/region.
* `event_description`: Description of the CloudWatch Event, helps identify and understand what's what.
* `target_input`: An optional JSON payload as a string that will be passed into the Lambda function as the `event`.
* `schedule_expression`: A `cron` or `rate` expression that defines when the event fires. [Documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html)
* `lambda_arn`: ARN of the Lambda function that should be called when the event fires.

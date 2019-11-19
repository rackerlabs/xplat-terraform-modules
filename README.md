# xplat-terraform-modules

Repository of Terraform modules for AWS Serverless use cases.


## Changes

### 0.12 breaking changes

#### Multiple variables changed to boolean type

The following modules had variables that were changed to boolean types. Consuming projects will need to change their input accordingly.

| Module            | Variables                               |
| ----------------- | :-------------------------------------: |
| apigateway        | enable_custom_domain, enable_monitoring |
| lambda            | enable-monitoring                       |
| lambda-cloudwatch | trigger_enabled                         |
| lambda-sqs-sns    | enable-monitoring                       |
| regional-waf      | enabled                                 |

#### Lambda

The `lambda-in-vpc`, `lambda-in-vpc-with-s3` and `lambda-with-s3` modules have been removed. Instead use the `lambda` module, with the same arguments as before except for the following:

* the variables `subnet_ids` and `security_group_ids` have gone away. Instead pass in `vpc_config` as an object containing two values with the keys `subnet_ids` and `security_group_ids`. This change allows manipulating the `vpc_config` property of the lambda resource directly.

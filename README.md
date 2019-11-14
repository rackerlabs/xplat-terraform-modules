# xplat-terraform-modules

Repository of Terraform modules for AWS Serverless use cases.


## Changes

### 0.12 breaking changes

#### Lambda

The `lambda-in-vpc`, `lambda-in-vpc-with-s3` and `lambda-with-s3` modules have been removed. Instead use the `lambda` module, with the same arguments as before except for the following:

* the variables `subnet_ids` and `security_group_ids` have gone away. Instead pass in `vpc_config` as a map containing two values with the keys `subnet_ids` and `security_group_ids`. This change allows manipulating the `vpc_config` property of the lambda resource directly.

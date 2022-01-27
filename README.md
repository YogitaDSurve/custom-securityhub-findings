## Custom Security Hub Findings

#### Custom Security Hub Findings is a repository that allows AWS users to import custom findings into Security Hub using AWS Lambda and get email notifications.


This repo primarily use the following services:

- [AWS Lambda](https://aws.amazon.com/security-hub/)
- [AWS Security Hub](https://aws.amazon.com/lambda/)

----
### Pre-requisite
* [Python](https://www.python.org/downloads/) (Python 3)
* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) (version 3.69.0 and above)

----

### Code Walkthrough
* As the first step, we enable Security Hub in two regions using [aws_securityhub_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_account).
* Next we create [EventBridge rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) that triggers the [Lambda function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function).
* Lambda function uses [batch_import_findings](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/securityhub.html#SecurityHub.Client.batch_import_findings) function by boto3 that imports the custom finding in Security Hub
* In next step, we create one more [EventBridge rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) that has the source of security hub and targets it to [SNS topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic)
---
### Buy me a coffee

Whether you use this project, have learned something from it, or just like it, please consider supporting it by buying me a coffee, so I can dedicate more time on open-source projects like this :)

<a href="https://www.buymeacoffee.com/igorantun" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>

----
### Reference
- [AWS Security Hub ](https://docs.aws.amazon.com/securityhub/latest/userguide/what-is-securityhub.html)
- [AWS EventBridge](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html)
- [AWS Lambda](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)
- [AWS SNS](https://docs.aws.amazon.com/sns/latest/dg/welcome.html)

----
### License
>You can check out the full license [here](https://github.com/YogitaDSurve/custom-securityhub-findings/blob/main/LICENSE)

This project is licensed under the terms of the MIT license.

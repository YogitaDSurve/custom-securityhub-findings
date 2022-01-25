resource "aws_cloudwatch_event_rule" "security_notification" {
  name        = "security_notification"
  description = "custom security hub findings notification"
  event_pattern = jsonencode({
    "source" : [
      "aws.securityhub"
    ],
    "detail-type" : [
      "Security Hub Findings - Imported"
    ],
    "detail" : {
      "findings" : {
        "Description" : [
          "IAM User Created",
        ],
        "Compliance" : {
          "Status" : [
            "FAILED"
          ]
        },
        "Workflow" : {
          "Status" : ["NEW"]
        },
        "RecordState" : ["ACTIVE"],
        "Resources" : {
          "Type" : [
            "AwsIAM"
          ]
        }
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "security_event_target_sns" {
  target_id = "security_event_sns"
  rule      = aws_cloudwatch_event_rule.security_notification.id
  arn       = var.sns_topic_arn
}
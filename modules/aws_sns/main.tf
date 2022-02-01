data "aws_caller_identity" "current" {}

locals {
  current_account_id = data.aws_caller_identity.current.account_id
  notification_email = var.notification_email
}

data "aws_iam_policy_document" "sns_topic_encryption_key_policy" {
  statement {
    sid     = "EnableIAMUserPermissions"
    effect  = "Allow"
    actions = ["kms:*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.current_account_id}:root"]
    }
    resources = ["*"]
  }
  statement {
    sid    = "AllowCloudWatchEventToUseKey"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*"
    ]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    resources = ["*"]
  }
}

resource "aws_kms_key" "sns_topic_encryption_key" {
  description         = "SNS Topic Encryption Key"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.sns_topic_encryption_key_policy.json
}

resource "aws_sns_topic" "security_notifications" {
  name              = "security_notifications"
  kms_master_key_id = aws_kms_key.sns_topic_encryption_key.key_id
}
resource "aws_sns_topic_subscription" "sns_to_security_email" {
  topic_arn = aws_sns_topic.security_notifications.arn
  protocol  = "email"
  endpoint  = local.notification_email
}

resource "aws_sns_topic_policy" "security_notification_sns_policy" {
  arn    = aws_sns_topic.security_notifications.arn
  policy = data.aws_iam_policy_document.security_notifications_policy.json
}

data "aws_iam_policy_document" "security_notifications_policy" {
  statement {
    sid    = "AllowSecurityToolingAccountToPublishToSNSTopic"
    effect = "Allow"
    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [aws_sns_topic.security_notifications.arn]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values   = [local.current_account_id]
    }
  }
  statement {
    sid     = "AllowEventBridgeToPublishToSNSTopic"
    effect  = "Allow"
    actions = ["sns:Publish"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    resources = [aws_sns_topic.security_notifications.arn]
  }
}
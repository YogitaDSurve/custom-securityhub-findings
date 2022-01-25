output "security_notification_topic_arn" {
  value = aws_sns_topic.security_notifications.arn
}

output "sns_topic_encryption_key" {
  value = aws_kms_key.sns_topic_encryption_key.arn
}

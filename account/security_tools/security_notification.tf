module "security_hub_notification" {
  source        = "../../modules/security_hub_notification"
  sns_topic_arn = local.sns_notification_topic_arn_us_east_1
}

locals {
  sns_notification_topic_arn_us_east_1 = module.sns_notification_for_us_east_1.security_notification_topic_arn
  sns_notification_topic_arn_us_east_2 = module.sns_notification_for_us_east_2.security_notification_topic_arn
}

module "sns_notification_for_us_east_1" {
source             = "../../modules/aws_sns"
notification_email = "your_email@domain.com"
}

module "sns_notification_for_us_east_2" {
source             = "../../modules/aws_sns"
notification_email = "your_email@domain.com"
}

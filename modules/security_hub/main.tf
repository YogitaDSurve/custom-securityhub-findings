locals {
  securityhub_standards_control            = "arn:aws:securityhub:${data.aws_region.current_region.name}:${data.aws_caller_identity.current_account_id.account_id}"
}

resource "aws_securityhub_organization_configuration" "enable_security_hub_for_organization" {
  auto_enable = true
}

data "aws_region" "current_region" {}
data "aws_caller_identity" "current_account_id" {}


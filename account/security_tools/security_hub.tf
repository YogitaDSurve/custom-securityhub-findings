module "security_hub_for_us_east_1" {
  source = "../../modules/security_hub"
}

module "security_hub_for_us_east_2" {
  source = "../../modules/security_hub"
  providers = {
    aws = aws.us_east_2
  }
}

resource "aws_securityhub_finding_aggregator" "security_tools_securityhub_finding_aggregator" {
  linking_mode      = "SPECIFIED_REGIONS"
  specified_regions = ["us-east-2"]
}

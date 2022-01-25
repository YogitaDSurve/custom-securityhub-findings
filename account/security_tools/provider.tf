locals {
  owner_name       = "securityhub-finidngs"
  env_name         = "security-tools"
  terraform_status = true
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      owner     = local.owner_name
      env       = local.env_name
      terraform = local.terraform_status
    }
  }
}

provider "aws" {
  alias  = "us_east_2"
  region = "us-east-2"
  default_tags {
    tags = {
      owner     = local.owner_name
      env       = local.env_name
      terraform = local.terraform_status
    }
  }
}


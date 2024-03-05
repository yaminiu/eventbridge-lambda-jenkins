data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}
data "aws_iam_session_context" "current" {
  # This data source provides information on the IAM source role of an STS assumed role
  # For non-role ARNs, this data source simply passes the ARN through issuer ARN
  # Ref https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2327#issuecomment-1355581682
  # Ref https://github.com/hashicorp/terraform-provider-aws/issues/28381
  arn = data.aws_caller_identity.current.arn
}

locals {
  region             = var.region != null ? var.region : data.aws_region.current.name
  azs                = slice(data.aws_availability_zones.available.names, 0, 3)
  lambda_func_name   = "${var.environment}-${var.service}-${var.application}"
  lambda_role_name   = "${var.environment}-${var.service}-${var.application}-execution-role"
  lambda_policy_name = "${var.environment}-${var.service}-${var.application}-policy"
  base_tags = {
    "Cost Center" = "TX560"
    "Tenant"      = "own"
    SNow_GUID     = upper(var.snow_guid)
    Owner         = "${var.owner}"
    Application   = upper(var.application)
    Service       = upper(var.service)
    Environment   = upper(var.environment)
  }
  tags = merge(
    var.tags,
    local.base_tags,
  )
}

# resource "time_static" "epoch" {}
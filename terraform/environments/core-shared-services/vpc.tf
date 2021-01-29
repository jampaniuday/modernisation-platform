locals {
  networking = {
    live_data     = "10.231.0.0/19"
    non_live_data = "10.231.32.0/19"
  }
}

module "vpc" {
  for_each = local.networking
  source   = "../../modules/core-vpc"

  # CIDRs
  vpc_cidr = each.value

  # Transit Gateway ID
  transit_gateway_id = data.aws_ec2_transit_gateway.transit-gateway.id

  # private gateway type
  #   nat = Nat Gateway
  #   transit = Transit Gateway
  #   none = no gateway for internal traffic
  gateway = "transit"

  # VPC Flow Logs
  vpc_flow_log_iam_role = data.aws_iam_role.vpc-flow-log.arn

  # Tags
  tags_common = local.tags
  tags_prefix = each.key
}

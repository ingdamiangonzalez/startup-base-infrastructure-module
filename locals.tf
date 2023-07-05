locals {

  common_name = lower("${var.project_name}-${var.environment}")

  vpce_name = "${local.common_name}-vpc-endpoint"

  private_hosted_zone_name = "${local.common_name}.resource"

  cloud_map_private_namespace_name = "${local.common_name}.local"


  alb_sg_public_name = "${local.common_name}-alb-security-group"
  rds_sg_name        = "${local.common_name}-rds-security-group"

  common_tags = {
    Application = var.project_name
    Environment = var.environment
    Provisioner = "terraform"
    Owner       = "Devops"
    Module      = "baseinfrastructure"
    Common_name = local.common_name
  }

  tags_security_group_vpce = merge(local.common_tags, {
    Name = local.vpce_name
  })


  tags_security_group_alb_public = merge(local.common_tags, {
    Name = "${local.common_name}-alb-security-group"
  })

  tags_security_group_rds = merge(local.common_tags, {
    Name = "${local.common_name}-rds-security-group"
  })

}

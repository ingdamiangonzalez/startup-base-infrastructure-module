locals {
  condition_ecs_insights_status = var.ecs_container_insights ? "enabled" : "disabled"
  condition_single_nat          = var.one_nat_gateway_per_az == true ? false : true
}

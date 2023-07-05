/*----------------------------------------------------------------------*/
/* General | Variable Definition                                        */
/*----------------------------------------------------------------------*/

variable "environment" {
  type        = string
  description = "(Required) Environment, could be: production|staging|development"
}

variable "project_name" {
  type        = string
  description = "(Required) Project name"
}

variable "aws_region" {
  type        = string
  description = "aws region"
}

/*----------------------------------------------------------------------*/
/* VPC | Variable Definition                                            */
/*----------------------------------------------------------------------*/

variable "vpc_cidr" {
  type        = string
  description = "(Required) VPC CIDR"
}

variable "vpc_private_subnets" {
  type        = list(string)
  description = "(Required) A list of private subnets inside the VPC"
}

variable "vpc_public_subnets" {
  type        = list(string)
  description = "(Required) A list of public subnets inside the VPC"
}

variable "vpc_enable_ecr_endpoints" {
  type        = bool
  description = "(Required) Whether to enable the two vpc endpoints for ECR registry"
}

variable "vpc_enable_logs_endpoint" {
  type        = bool
  description = "(Required) Whether to enable a vpc endpoint for sending logs to CloudWatch"
}

variable "one_nat_gateway_per_az" {
  type        = bool
  description = "(Required) One nat gateway per availability zone"
  default     = false

}

/*----------------------------------------------------------------------*/
/* ECS | Cluster Variable Definition                                    */
/*----------------------------------------------------------------------*/

variable "ecs_container_insights" {
  type        = bool
  description = "(Required) Whether to enable Container Insights for ECS Cluster"
}

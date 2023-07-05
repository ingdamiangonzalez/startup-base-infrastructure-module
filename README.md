# infra-base-module
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~>2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_iam_role.ecs_tasks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ecs_tasks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_route53_zone.resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_security_group.alb_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.vpc_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_service_discovery_private_dns_namespace.namespace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace) | resource |
| [aws_iam_policy.aws_ecs_tasks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.ecs_tasks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | aws region | `string` | n/a | yes |
| <a name="input_ecs_container_insights"></a> [ecs\_container\_insights](#input\_ecs\_container\_insights) | (Required) Whether to enable Container Insights for ECS Cluster | `bool` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) Environment, could be: production\|staging\|development | `string` | n/a | yes |
| <a name="input_one_nat_gateway_per_az"></a> [one\_nat\_gateway\_per\_az](#input\_one\_nat\_gateway\_per\_az) | (Required) One nat gateway per availability zone | `bool` | `false` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | (Required) Project name | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | (Required) VPC CIDR | `string` | n/a | yes |
| <a name="input_vpc_enable_ecr_endpoints"></a> [vpc\_enable\_ecr\_endpoints](#input\_vpc\_enable\_ecr\_endpoints) | (Required) Whether to enable the two vpc endpoints for ECR registry | `bool` | n/a | yes |
| <a name="input_vpc_enable_logs_endpoint"></a> [vpc\_enable\_logs\_endpoint](#input\_vpc\_enable\_logs\_endpoint) | (Required) Whether to enable a vpc endpoint for sending logs to CloudWatch | `bool` | n/a | yes |
| <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets) | (Required) A list of private subnets inside the VPC | `list(string)` | n/a | yes |
| <a name="input_vpc_public_subnets"></a> [vpc\_public\_subnets](#input\_vpc\_public\_subnets) | (Required) A list of public subnets inside the VPC | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | ECS Cluster Name |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

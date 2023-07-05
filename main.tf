/*----------------------------------------------------------------------*/
/* VPC | Public & Private Subnets, NAT Gateway, VPC Endpoints            */
/*----------------------------------------------------------------------*/
module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "~>5.0.0"
  name                 = local.common_name
  cidr                 = var.vpc_cidr
  azs                  = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets      = var.vpc_private_subnets
  public_subnets       = var.vpc_public_subnets
  enable_dns_hostnames = true
  ## No High Availabiliy but cheaper
  enable_nat_gateway     = true
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  single_nat_gateway     = local.condition_single_nat
  ## Gateway VPC Endpoints (Free)
  enable_s3_endpoint       = false
  enable_dynamodb_endpoint = false
  ## Interface VPC Endpoints (Not Free)
  # Good for security and performance because traffic travels inside VPC,
  # but cost per interface, 7.2 USD/Month x Attached Subnet.
  # Example: 2 ECR Endpoints (API/DKR) x 3 Subnets x 1 VPC = 43.2 USD/Month
  # Example: 2 ECR Endpoints x 3 Subnets x 2 VPC (Prod/Stage) = 86.4 USD/Month
  enable_ecr_api_endpoint              = var.vpc_enable_ecr_endpoints
  ecr_api_endpoint_private_dns_enabled = var.vpc_enable_ecr_endpoints
  ecr_api_endpoint_security_group_ids  = [aws_security_group.vpc_endpoint.id]

  enable_ecr_dkr_endpoint              = var.vpc_enable_ecr_endpoints
  ecr_dkr_endpoint_private_dns_enabled = var.vpc_enable_ecr_endpoints
  ecr_dkr_endpoint_security_group_ids  = [aws_security_group.vpc_endpoint.id]

  enable_logs_endpoint              = var.vpc_enable_logs_endpoint
  logs_endpoint_private_dns_enabled = var.vpc_enable_logs_endpoint
  logs_endpoint_security_group_ids  = [aws_security_group.vpc_endpoint.id]

  ## Tags
  private_subnet_tags = {
    Tier = "Private"
  }
  public_subnet_tags = {
    Tier = "Public"
  }

  tags = local.common_tags
}


/*----------------------------------------------------------------------*/
/* Route53 | Private zone & records                                     */
/*----------------------------------------------------------------------*/

resource "aws_route53_zone" "resource" {
  name    = local.private_hosted_zone_name
  comment = "Internal Hosted Zone for resources on environment ${var.environment}"

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  tags = local.common_tags
}


/*----------------------------------------------------------------------*/
/* Cloud Map | Private DNS Namespace                                    */
/*----------------------------------------------------------------------*/

resource "aws_service_discovery_private_dns_namespace" "namespace" {
  name        = local.cloud_map_private_namespace_name
  description = "Namespace for Service Discovery service on environment ${var.environment}"
  vpc         = module.vpc.vpc_id

  tags = local.common_tags
}

/*----------------------------------------------------------------------*/
/* Backend | ECS Cluster                                                */
/*----------------------------------------------------------------------*/

resource "aws_ecs_cluster" "cluster" {
  name = local.common_name
  setting {
    name  = "containerInsights"
    value = local.condition_ecs_insights_status
  }

  tags = local.common_tags
}


resource "aws_ecs_cluster_capacity_providers" "cluster" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

/*----------------------------------------------------------------------*/
/* Security Group | ALB Public                                          */
/*----------------------------------------------------------------------*/

resource "aws_security_group" "alb_public" {
  name   = local.alb_sg_public_name
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Allow all when using this Security Group"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = true
  }

  ingress {
    description = "Allow public access to HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = 6
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow public access to HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = 6
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all to Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags_security_group_alb_public
}

/*----------------------------------------------------------------------*/
/* Security Group | Aurora RDS                                          */
/*----------------------------------------------------------------------*/

resource "aws_security_group" "rds" {
  name   = local.rds_sg_name
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Allow all when using this Security Group"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = true
  }

  ingress {
    description = "Allow private access from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = 6
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Allow all to Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags_security_group_rds
}


/*----------------------------------------------------------------------*/
/* ECS Tasks Service Role                                               */
/*----------------------------------------------------------------------*/

resource "aws_iam_role" "ecs_tasks" {
  name               = "${local.common_name}-ecs-tasks-role"
  path               = "/service-role/"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_role.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ecs_tasks" {
  role       = aws_iam_role.ecs_tasks.name
  policy_arn = data.aws_iam_policy.aws_ecs_tasks_policy.arn
}


/*----------------------------------------------------------------------*/
/* S3 Service Role                                                      */
/*----------------------------------------------------------------------*/

resource "aws_iam_role" "s3" {
  name               = "${local.common_name}-s3-role"
  path               = "/service-role/"
  assume_role_policy = data.aws_iam_policy_document.s3_role.json

  tags = local.common_tags
}

resource "aws_iam_role_policy" "s3" {
  name   = "${local.common_name}-s3-role-policy"
  role   = aws_iam_role.s3.id
  policy = data.aws_iam_policy_document.s3_role_policy.json
}

/*----------------------------------------------------------------------*/
/* Security Group | VPC Endpoints                                        */
/*----------------------------------------------------------------------*/

resource "aws_security_group" "vpc_endpoint" {
  name   = local.vpce_name
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Allow all when using this Security Group"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = true
  }

  ingress {
    description = "Allow public access to HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = 6
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow public access to HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = 6
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all to Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags_security_group_vpce
}

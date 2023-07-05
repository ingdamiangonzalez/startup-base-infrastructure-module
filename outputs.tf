output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "ecs_cluster_name" {
  description = "ECS Cluster Name"
  value       = aws_ecs_cluster.cluster.name
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value = module.ecs.cluster_arn
}

output "rds_database_arn" {
  description = "ARN of the RDS database instance"
  value = module.rds.db_arn
}

output "cloudfront_dns" {
  description = "Domain name of the Cloudfront distribution"
  value = module.cloudfront.cloudfront_dns
}

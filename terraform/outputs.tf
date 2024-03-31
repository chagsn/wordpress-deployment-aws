output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = module.ecs.cluster_arn
}

output "rds_database_arn" {
  description = "ARN of the RDS database instance"
  value       = module.rds.db_arn
}

output "cloudfront_dns" {
  description = "DNS name of the cloudfront distribution"
  value       = module.cloudfront.cloudfront_dns
}

# output "website_fqdn" {
#   description = "Fully Qualified Domain Name of our wordpress website"
#   value       = module.route53.website_fqdn
# }
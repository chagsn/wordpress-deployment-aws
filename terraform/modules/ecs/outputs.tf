output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value = module.wordpress-cluster.arn
}

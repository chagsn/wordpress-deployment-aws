output "efs_id" {
  description = "ID of the EFS instance"
  value = module.efs.id
}

output "efs_arn" {
  description = "ARN of the EFS instance"
  value = module.efs.arn
}

output "efs_security_group_id" {
  description = "ID of the EFS security group"
  value = module.efs.security_group_id
}
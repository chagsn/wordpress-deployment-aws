output "db_address" {
  description = "Address of the RDS database instance"
  value = module.db.db_instance_address
}

output "db_password_secret_arn" {
  description = "ARN of the secret created in Secrets Manager containing the password"
  value = module.db.db_instance_master_user_secret_arn
}
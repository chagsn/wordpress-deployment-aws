variable "env" {
  description = "Deployment environment: dev or prod"
  type = string
}

variable "backup_region" {
  description = "Name oh the backup region"
  type = string
}

variable "rds_db_arn" {
  description = "ARN of the RDS database instance"
  type = string
}

variable "efs_arn" {
  description = "ARN of the EFS shared wordpress storage"
  type = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket hosting Wordpress static content"
  type = string
}
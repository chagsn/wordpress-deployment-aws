output "s3_logs_dns" {
  description = "DNS name of the S3 bucket dedicated to logs storage"
  value = module.s3_bucket_for_logs.s3_bucket_bucket_domain_name
}

output "s3_wordpress_media_regional_dns" {
  description = "Regional DNS name of the S3 bucket hosting wordpress media"
  value = module.s3_wordpress_media.s3_bucket_bucket_regional_domain_name
}

output "s3_wordpress_media_arn" {
  description = "ARN of the S3 bucket hosting wordpress media"
  value = module.s3_wordpress_media.s3_bucket_arn
}
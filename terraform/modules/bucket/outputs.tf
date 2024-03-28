output "S3_logs_dns" {
  value = module.s3_bucket_for_logs.s3_bucket_bucket_domain_name
}

output "S3_one_regional_dns" {
  value = module.s3_one.s3_bucket_bucket_regional_domain_name
}

output "wordpress_bucket_arn" {
  value = module.s3_one.s3_bucket_arn
}
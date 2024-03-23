output "cloudfront_dns" {
  value = module.cdn.cloudfront_distribution_domain_name
}

output "cloudfront_id" {
  value = module.cdn.cloudfront_distribution_hosted_zone_id
}
output "cloudfront_dns" {
  description = "Domain name of the created cloudfront distribution"
  value = module.cdn.cloudfront_distribution_domain_name
}

output "cloudfront_id" {
  description = "ID of the created Cloudfront distribution"
  value = module.cdn.cloudfront_distribution_hosted_zone_id
}

output "cloudfront_oai_arns" {
  description = "ARNs of the Cloudfront distribution Origin Access Identities"
  value = module.cdn.cloudfront_origin_access_identity_iam_arns
}

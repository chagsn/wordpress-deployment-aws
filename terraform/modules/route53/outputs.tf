output "website_fqdn" {
  description = "Fully Qualified Domain Name of our wordpress website"
  value = module.records.route53_record_fqdn
}

variable "domain_name" {
  description = "Hosted zone name"
  type = string
}

variable "cloudfront_dns" {
  description = "Domain name of the Cloudfront distribution"
  type = string
}

variable "cloudfront_id" {
  description = "ID of the Cloudfront distribution"
  type = string
}

variable "subdomain_name" {
  description = "Name of the subdomain to be routed to Cloufront distribution"
  type = string
}
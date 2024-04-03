variable "env" {
  description = "Deployment environment: dev or prod"
  type = string
}

variable "cloudfront_oai_arns" {
  description = "ARNs of the Cloudfront distribution Origin Access Identities"
  type = list
}

variable "S3_logs_dns" {
  type = string
}

variable "S3_one_regional_dns" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "viewer_certificate" {
  description = "The SSL configuration for this distribution"
  type        = any
  default = {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1"
  }
}
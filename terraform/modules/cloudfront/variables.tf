variable "s3_logs_dns" {
  description = "DNS name of the S3 bucket dedicated to Cloudfront logs storage"
  type = string
}

variable "s3_wordpress_media_dns" {
  description = "DNS name of the S3 bucket hosting wordpress media"
  type = string
}

variable "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  type = string
}
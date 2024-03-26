module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = ["wordpress.stormpoei-web2.com"]

  comment             = "Web 2 CloudFront"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  create_origin_access_identity = true
  origin_access_identities = {
    s3_bucket_one = "My awesome CloudFront can access"
  }

  logging_config = {
    bucket = var.S3_logs_dns
    prefix = "cloudfront"
  }

  origin = {
    alb_origin = {
      domain_name = var.alb_dns_name
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
    }

    s3_one = {
      domain_name = var.S3_one_regional_dns
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one"
      }
    }
  }

  default_cache_behavior = {
    target_origin_id           = "alb_origin"
    viewer_protocol_policy     = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/static/*"
      target_origin_id       = "s3_one"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      query_string    = true
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = "arn:aws:acm:eu-west-3:962480255828:certificate/cb002cc4-eef7-4f5a-9979-d2059c1a70a7"
    ssl_support_method  = "sni-only"
    region              = "eu-west-3"
    #cloudfront_default_certificate = true
    #minimum_protocol_version: "TLSv1"
  }
}
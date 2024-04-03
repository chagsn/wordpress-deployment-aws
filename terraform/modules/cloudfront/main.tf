module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"
  version = "3.4.0"

  /* We did not manage to install custom TLS certificate on the Cloudfront distribution due to SCP issues
   (no access to Certificate Manager), therefore we used the Cloudfront default TLS certificate.
   As a consequence only the CloudFront domain name is available for the distribution, we could not use
   a custom DNS name */
  
  # aliases = ["stormpoei-web2.com"]

  comment             = "Web 2 CloudFront"

  # Distribution TLS certificate
  # viewer_certificate = {
  #   acm_certificate_arn      = ""
  #   ssl_support_method       = "sni-only"
  # }
  viewer_certificate = {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1"
  }

  # Enabling IPv6
  is_ipv6_enabled     = true

  # Cloudfront price class
  price_class         = "PriceClass_All"

  # Creating origin access identity for S3 bucket origin
  create_origin_access_identity = true
  origin_access_identities = {
    s3-wordpress-oai = "Allow access to wordpress media s3 bucket"
  }

  # Enabling logs writing in dedicated bucket
  logging_config = {
    bucket = "${var.s3_logs_dns}"
    prefix = "cloudfront"
  }

  # Origins of the distribution
  origin = {
    # Origin: ALB
    alb_origin = {
      domain_name = "${var.alb_dns_name}"
      custom_origin_config = {
        http_port              = 80
        /* Since no TLS certificate could be installed on ALB, 
        connections with ALB are HTTP-based only */
        origin_protocol_policy = "http-only"
        https_port             = 443                                # Required by Terraform
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]    # Required by Terraform
      }
    }
    # Origin: S3 bucket for wordpress media
    s3_origin = {
      domain_name = "${var.s3_wordpress_media_dns}"
      s3_origin_config = {
        origin_access_identity = "s3-wordpress-oai"
      }
    }
  }

  # Cache behavior for ALB origin
  default_cache_behavior = {
    target_origin_id           = "alb_origin"
    viewer_protocol_policy     = "allow-all"
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

  # Cache behavior for S3 origin
  ordered_cache_behavior = [
    {
      path_pattern           = "wp-content/uploads/*"
      target_origin_id       = "s3_origin"
      viewer_protocol_policy = "allow-all"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      query_string    = true
    }
  ]
}
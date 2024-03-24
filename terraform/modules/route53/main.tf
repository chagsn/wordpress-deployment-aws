module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_id = data.aws_route53_zone.this.zone_id

  records = [
    {
      name = var.subdomain
      type = "A"
      alias = {
        name    = var.cloudfront_dns
        zone_id = var.cloudfront_id
      }
    },
  ]
}

data "aws_route53_zone" "this" {
  name = var.domain_name
}
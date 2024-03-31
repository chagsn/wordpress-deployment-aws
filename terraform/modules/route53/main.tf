# Retrieving Route 53 hosted zone
data "aws_route53_zone" "stormpoei_web2_zone" {
  name = var.domain_name
}

# Configuration of an alias record to route domain name to Cloudfront distribution
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_id = data.aws_route53_zone.stormpoei_web2_zone.zone_id

  records = [
    {
      name = "${var.subdomain_name}"
      type = "A"
      alias = {
        name    = "${var.cloudfront_dns}"
        zone_id = "${var.cloudfront_id}"
      }
    },
  ]
}
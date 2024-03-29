# Configuration of 
module "s3_bucket_for_logs" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.1"

  bucket = "${var.env}-bucket-for-logs-storm-poei-web2"
  acl    = "log-delivery-write"

  # Allow deletion of non-empty bucket
  force_destroy = true

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  attach_elb_log_delivery_policy = true  # Required for ALB logs
  attach_lb_log_delivery_policy  = true  # Required for ALB/NLB logs
}

module "s3_one" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.1"

  bucket = "${var.env}-bucket-for-wordpress-storm-poei-web2"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  # Allow deletion of non-empty bucket
  force_destroy = true

  # Block public policy configuration: allow access via ACL (required for wordpress static content delivery)
  block_public_acls = false
  block_public_policy = true
}
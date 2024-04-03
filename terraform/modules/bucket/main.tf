# Configuration of S3 bucket dedicated to logs storage
module "s3_bucket_for_logs" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.1"

  bucket = "${var.env}-bucket-for-cloudfront-logs-storm-poei-web2"

  # Specific access/ownership policy for logs storing buckets
  acl    = "log-delivery-write"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  # Allowing deletion of non-empty bucket
  force_destroy = true

  # Granting full control of bucket to bucket owner

  # Enabling bucket versioning
  versioning = {
  enabled = true
  }

  # Block public access
  block_public_acls = true
  block_public_policy = true
}

# Creation of a bucket policy allowing Cloudfront to write logs into the bucket
data "aws_iam_policy_document" "allow_cloudfront_to_write_logs" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = [
      "s3:PutObject",
    ]
    resources = ["${module.s3_bucket_for_logs.s3_bucket_arn}/logs/*"]
  }
}

resource "aws_s3_bucket_policy" "allow_cloudfront_to_write_logs" {
  bucket = module.s3_bucket_for_logs.s3_bucket_id
  policy = data.aws_iam_policy_document.allow_cloudfront_to_write_logs.json
}


# Configuration of S3 bucket hosting wordpress media
module "s3_wordpress_media" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.1"

  bucket = "${var.env}-bucket-for-wordpress-media-storm-poei-web2"

  # Granting full control of bucket to bucket owner
  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  # Enabling bucket versioning
  versioning = {
  enabled = true
  }

  # Allowing deletion of non-empty bucket
  force_destroy = true

  # Block public access
  block_public_acls = true
  block_public_policy = true
}

# Creation of a bucket policy allowing access to Cloudfront Origin Access Identity for read operations
data "aws_iam_policy_document" "allow_access_from_cloudfront" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = var.cloudfront_oai_arns
    }
    actions = [
      "s3:GetObject",
    ]
    resources = ["${module.s3_wordpress_media.s3_bucket_arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = module.s3_wordpress_media.s3_bucket_id
  policy = data.aws_iam_policy_document.allow_access_from_cloudfront.json
}


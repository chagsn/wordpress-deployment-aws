module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.6.2"

  # File system
  name           = "wordpress-data"
  creation_token = "wordpress-data-token"

  # No encryption
  encrypted = false

  # Mount targets
  mount_targets = {
    "efs-mount-target-1" = {
      subnet_id = var.wordpress_subnet_ids[0]
    }
    "efs-mount-target-2" = {
      subnet_id = var.wordpress_subnet_ids[1]
    }
  }

  create_security_group = false

  tags = {
    Terraform   = "true"
    Environment = "${var.env}"
  }
}
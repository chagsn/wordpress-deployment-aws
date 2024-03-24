module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.6.2"

  name           = "${var.env}-wordpress-efs-storage"

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

  security_group_name = "${var.env}-efs-sg"
  security_group_vpc_id = var.vpc_id
  security_group_rules = {
    ingress = {
      type = "ingress"
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      source_security_group_id = var.ecs_security_group_id
    }
    egress = {
      type = "egress"
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      source_security_group_id = var.ecs_security_group_id
    }

  }

  tags = {
    Terraform   = "true"
    Environment = "${var.env}"
  }
}
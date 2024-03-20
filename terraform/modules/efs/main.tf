module "efs" {
  source = "terraform-aws-modules/efs/aws"

  # File system
  name           = "wordpress-data"
  creation_token = "wordpress-data-token"



  # Mount targets / security group
  mount_targets = {
    "eu-west-1a" = {
      subnet_id = "${var.wordpress_subnet_ids[0]}"
    }
    "eu-west-1b" = {
      subnet_id = "${var.wordpress_subnet_ids[1]}"
    }
  }

  security_group_description = "Example EFS security group"
  security_group_vpc_id      = var.vpc_id
  security_group_rules = {
    vpc = {
      # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
      description = "NFS ingress from VPC private subnets"
      cidr_blocks = var.vpc_private_subnet_cidr_block
    }
  }

  # Access point(s)
  access_points = {
    posix_example = {
      name = "posix-example"
      posix_user = {
        gid            = 1001
        uid            = 1001
        secondary_gids = [1002]
      }

      tags = {
        Additionl = "yes"
      }
    }
    root_example = {
      root_directory = {
        path = "/example"
        creation_info = {
          owner_gid   = 1001
          owner_uid   = 1001
          permissions = "755"
        }
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "${var.env}"
  }
}
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.8.0"

  name    = "${var.env}-alb"

  # Networking
  vpc_id = var.vpc_id
  subnets = var.public_subnets_ids
  create_security_group = false
  security_groups = [var.alb_security_group_id]

  # Disabling deletion protection
  enable_deletion_protection = false

  # Listeners
  listeners = {
    http = {
      port            = 80
      protocol        = "HTTP"
      forward = {
        target_group_key = "wordpress-tg"
      }

    # http-https-redirect = {
    #   port     = 80
    #   protocol = "HTTP"
    #   redirect = {
    #     port        = "443"
    #     protocol    = "HTTPS"
    #     status_code = "HTTP_301"
    #   }
    # }
    # https = {
    #   port            = 443
    #   protocol        = "HTTPS"
    #   certificate_arn = "arn:aws:acm:eu-west-3:962480255828:certificate/85995d2a-5a2a-4023-a175-ea879c59a283"

    #   forward = {
    #     target_group_key = "wordpress-tg"
    #   }
    }
  }

  # Target group configuration
  target_groups = {
    wordpress-tg = {
      name        = "${var.env}-wordpress-tg"
      protocol    = "HTTP"
      port        = 80
      target_type = "ip"
      create_attachment = false
      health_check = {
        interval            = 30
        path                = var.health_check_path
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 3
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "${var.env}"
  }
}
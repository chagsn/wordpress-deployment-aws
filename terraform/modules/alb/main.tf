module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.8.0"

  name    = "my-alb"
  vpc_id = var.vpc_id
  subnets = var.public_subnets_ids

  create_security_group = false

  listeners = {
    ex-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    ex-https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"

      forward = {
        target_group_key = "ex-instance"
      }
    }
  }

  target_groups = {
    ex-instance = {
      name        = "wordpress-containers"
      protocol    = "HTTP"
      port        = 80
      target_type = "instance"
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "${var.env}"
  }
}
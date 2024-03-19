# Configuration du VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.6.0"

  name = "${var.env}-vpc"
  cidr = "10.0.0.0/16"
  azs             = var.azs
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  tags = {
    Name = "${var.env}-vpc"
    Terraform = "true"
    Environment = "${var.env}"
  }
}

# Configuration des security groups
# Configuration du VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.6.0"

  name = "${var.env}-vpc"
  cidr = "10.0.0.0/16"
  azs             = var.azs

  # Create public subnet in each AZ
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  public_subnet_names = ["public_subnet1", "public_subnet2"]

  # Create private subnet for wordpress instances in each AZ
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_names = ["private_subnet1", "private_subnet2"]
  
  # Create private subnet for RDS instances in each AZ
  database_subnets = ["10.0.201.0/24", "10.0.202.0/24"]
  database_subnet_names = ["DB_subnet1", "DB_subnet2"]

  # Create one NAT gateway public subnet of each AZ
  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  # Disable default security group creation
  manage_default_security_group = false

  tags = {
#    Name = "${var.env}-vpc"
    Terraform = "true"
    Environment = "${var.env}"
  }
}

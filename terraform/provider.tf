terraform {

  # Remote backend
  backend "s3" {
    profile = "terraform"
    bucket  = "projet-storm-web2-terraform-backend"
    key     = "terraform.tfstate"
    region  = "eu-west-3" # la région ou se trouve le bucket
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  profile = "terraform"
  region  = "eu-west-3"
}
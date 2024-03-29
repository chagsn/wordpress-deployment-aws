terraform {

  # Remote backend
  backend "s3" {
    profile        = "terraform"
    bucket         = "projet-storm-web2-terraform-backend"
    key            = "terraform.tfstate"
    dynamodb_table = "projet-storm-web2-terraform-lock"
    region         = "eu-west-3"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider in deployment region (eu-west-3)
provider "aws" {
  #profile = "terraform"
  region  = "eu-west-3"
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

module "vpc" {
  source = "../../modules/vpc"
  
}

module "eks" {
  source = "../../modules/eks"
  subnet_ids = [
    module.vpc.private_subnet_ids[0],
    module.vpc.private_subnet_ids[1],
    module.vpc.public_subnet_ids[0],
    module.vpc.public_subnet_ids[1]
  ]

  private_subnet_ids = [
    module.vpc.private_subnet_ids[0],
    module.vpc.private_subnet_ids[1]
  ]
}

# module "iam" {
#   source = "../../modules/iam"
# }

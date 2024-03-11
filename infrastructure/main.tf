provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#Modules for VPC and EKS 

module "vpc" {
  source = "./modules/vpc"

  #Variables definition for module
  environment            = var.environment
  aws_region             = var.aws_region
  cidr_block             = var.cidr_block
  private_subnet_cidr_a  = var.private_subnet_cidr_a
  private_subnet_cidr_b  = var.private_subnet_cidr_b
  public_subnet_cidr_a   = var.public_subnet_cidr_a
  public_subnet_cidr_b   = var.public_subnet_cidr_b
}

module "eks" {
  source = "./modules/eks"

  #Variables definition for module
  environment            = var.environment

  #Get subnets ids from VPC to EKS 
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

variable "environment" {
  type = string
  description = "environment name"
}

variable "aws_region" {
  type = string
}


variable "cidr_block" {
  description = "CIDR block for the VPC"
}


variable "private_subnet_cidr_a" {
  description = "CIDR block for private subnet in us-east-1a"
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for private subnet in us-east-1b"
}

variable "public_subnet_cidr_a" {
  description = "CIDR block for public subnet in us-east-1a"
}

variable "public_subnet_cidr_b" {
  description = "CIDR block for public subnet in us-east-1b"
}

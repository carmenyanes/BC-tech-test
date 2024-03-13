variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
}

variable "cidr_block" {
  type    = string
}

variable "private_subnet_cidr_a" {
  type    = string
}

variable "private_subnet_cidr_b" {
  type    = string
}

variable "public_subnet_cidr_a" {
  type    = string
}

variable "public_subnet_cidr_b" {
  type    = string
}
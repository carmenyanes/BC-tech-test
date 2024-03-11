variable "cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for private subnet in us-east-1a"
  default     = "10.0.0.0/19"
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for private subnet in us-east-1b"
  default     = "10.0.32.0/19"
}

variable "public_subnet_cidr_a" {
  description = "CIDR block for public subnet in us-east-1a"
  default     = "10.0.64.0/19"
}

variable "public_subnet_cidr_b" {
  description = "CIDR block for public subnet in us-east-1b"
  default     = "10.0.96.0/19"
}

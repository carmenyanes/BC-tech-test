variable "environment" {
  type = string
  description = "environment name"
}

variable "eks_node_instance_types" {
  description = "Instance types for the EKS node group"
  type        = list(string)
  default     = ["t2.medium"]
}


variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of IDs for the private subnets"
  type        = list(string)
}
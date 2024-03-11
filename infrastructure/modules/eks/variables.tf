variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  default     = "demo"
}

variable "eks_node_group_name" {
  description = "Name of the EKS node group"
  default     = "private-nodes"
}

variable "eks_node_instance_types" {
  description = "Instance types for the EKS node group"
  type        = list(string)
  default     = ["t2.micro"]
}


variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of IDs for the private subnets"
  type        = list(string)
}
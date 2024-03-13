output "eks_cluster_name" {
  value = aws_eks_cluster.demo.name
}

output "eks_node_group_name" {
  value = aws_eks_node_group.private-nodes.node_group_name
}

output "eks_node_instance_types" {
  value = var.eks_node_instance_types
}

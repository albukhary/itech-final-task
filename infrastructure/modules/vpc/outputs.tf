output "public_subnets_id" {
  value = aws_subnet.public[*].id
}

output "private_subnets_id" {
  value = aws_subnet.private[*].id
}

output "public_sg_id" {
  value = aws_security_group.public_sg.id
}

output "eks_cluster_sg_id" {
  value = aws_security_group.eks_cluster.id
}
output "eks_nodes_sg_id" {
  value = aws_security_group.eks_nodes.id
}

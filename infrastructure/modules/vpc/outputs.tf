output "public_subnets_id" {
  value = aws_subnet.public[*].id
}

output "private_subnets_id" {
  value = aws_subnet.private[*].id
}

output "public_sg_id" {
  value = aws_security_group.public_sg.id
}

output "data_plane_sg_id" {
  value = aws_security_group.data_plane_sg.id
}

output "control_plane_sg_id" {
  value = aws_security_group.control_plane_sg.id
}

output "data_plane_sg_name" {
  value = aws_security_group.data_plane_sg.name
}

output "control_plane_sg_name" {
  value = aws_security_group.control_plane_sg.name
}


### a different set of Security Groups

output "eks_cluster_sg_id" {
  value = aws_security_group.eks_cluster.id
}

output "eks_cluster_sg_name" {
  value = aws_security_group.eks_cluster.name
}

output "eks_nodes_sg_id" {
  value = aws_security_group.eks_nodes.id
}

output "eks_nodes_sg_name" {
  value = aws_security_group.eks_nodes.name
}

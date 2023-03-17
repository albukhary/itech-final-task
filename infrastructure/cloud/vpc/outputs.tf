output "public_subnets_id" {
  value = module.vpc.public_subnets_id
}

output "private_subnets_id" {
  value = module.vpc.private_subnets_id
}

output "public_sg_id" {
  value = module.vpc.public_sg_id
}

output "eks_cluster_sg_id" {
  value = module.vpc.eks_cluster_sg_id
}

output "eks_nodes_sg_id" {
  value = module.vpc.eks_nodes_sg_id
}
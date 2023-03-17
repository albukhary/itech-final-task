resource "aws_eks_cluster" "eks-cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.EKSClusterRole.arn
  version  = "1.25"

  vpc_config {
    subnet_ids              = flatten([var.public_subnets_id, var.private_subnets_id])
    security_group_ids      = flatten([var.eks_cluster_sg_id, var.eks_nodes_sg_id])
    endpoint_private_access = "true"
    endpoint_public_access  = "true"
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy
  ]
}
resource "aws_eks_node_group" "node-ec2" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = var.nodegroup_name
  node_role_arn   = aws_iam_role.NodeGroupRole.arn
  subnet_ids      = flatten([var.public_subnets_id]) #var.private_subnets_id, 

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  # ami_type       = "AL2_x86_64"
  # instance_types = ["t2.micro"]
  # capacity_type  = "ON_DEMAND"
  # disk_size      = 8

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  labels = {
    lifecycle = "OnDemand"
  }

  tags = {
    "kubernetes.io/cluster/${aws_eks_cluster.eks-cluster.name}" = "owned"
    Environment                                                 = "test"
  }

  depends_on = [
    aws_launch_template.example,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy
  ]
}
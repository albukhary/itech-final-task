# Create an EC2 instance
resource "aws_instance" "node" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = "itech-aws"
  security_groups = ["${aws_security_group.eks_nodes.id}"]
  subnet_id = aws_subnet.public[0].id

  associate_public_ip_address = true

  # Attach an IAM instance profile
  iam_instance_profile = aws_iam_instance_profile.node.name
  
  # # Connect the instance to the EKS cluster
  # user_data = <<-EOF
  #             #!/bin/bash
  #             echo 'export EKS_CLUSTER_NAME=${aws_eks_cluster.this.name}' >> /etc/environment
  #             echo 'export AWS_DEFAULT_REGION=${var.region}' >> /etc/environment
  #             curl --silent --location https://github.com/weaveworks/eksctl/releases/download/0.54.0/eksctl_Linux_amd64.tar.gz | tar xz -C /tmp
  #             mv /tmp/eksctl /usr/local/bin
  #             eksctl utils install-vpc-controllers --approve
  #             eksctl create nodegroup --cluster $EKS_CLUSTER_NAME --region $AWS_DEFAULT_REGION --name my-nodegroup --node-type t2.micro --nodes 1 --ssh-access --ssh-public-key my-key
  #             EOF

  tags = merge(
    var.tags, {
      "Name" = var.node_name
    }
  )
  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}


# Define the IAM instance profile
resource "aws_iam_instance_profile" "node" {
  name = "${var.project}-node"

  role = aws_iam_role.node.name
}

# # EKS Node IAM Role
# resource "aws_iam_role" "node" {
#   name = "${var.project}-Worker-Role"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.node.name
# }

# resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.node.name
# }

# resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.node.name
# }


# # EKS Node Security Group
# resource "aws_security_group" "eks_nodes" {
#   name        = "${var.project}-node-sg"
#   description = "Security group for all nodes in the cluster"
#   vpc_id      = aws_vpc.this.id

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name                                           = "${var.project}-node-sg"
#     "kubernetes.io/cluster/${var.project}-cluster" = "owned"
#   }
# }

# resource "aws_security_group_rule" "nodes_internal" {
#   description              = "Allow nodes to communicate with each other"
#   from_port                = 0
#   protocol                 = "-1"
#   security_group_id        = aws_security_group.eks_nodes.id
#   source_security_group_id = aws_security_group.eks_nodes.id
#   to_port                  = 65535
#   type                     = "ingress"
# }

# resource "aws_security_group_rule" "nodes_cluster_inbound" {
#   description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
#   from_port                = 1025
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.eks_nodes.id
#   source_security_group_id = aws_security_group.eks_cluster.id
#   to_port                  = 65535
#   type                     = "ingress"
# }

# # Added for testing
# resource "aws_security_group_rule" "nodes_cluster_outbound" {
#   description              = "Allow worker node talk to cluster"
#   from_port                = 0
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.eks_nodes.id
#   source_security_group_id = aws_security_group.eks_cluster.id
#   to_port                  = 65535
#   type                     = "egress"
# }
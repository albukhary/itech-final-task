# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster" {
  name        = "${var.project}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name                                           = "${var.project}-cluster-sg"
    "kubernetes.io/cluster/${var.project}-cluster" = "owned"
  }
}

resource "aws_security_group_rule" "cluster_inbound_nodes" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 0 #443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535 #443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound_nodes" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 0 #1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "egress"
}

# The next two are to fix problem of AWS ALB Webhook service connection refused
resource "aws_security_group_rule" "cluster_alb_webhook_inbound" {
  description       = "Open communication to AWS Load Balancer webhook service"
  from_port         = 9443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_cluster.id
  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = 9443
  type              = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound_all" {
  description       = "Allow cluster API Server to communicate everybody"
  from_port         = 0 
  protocol          = "-1"
  security_group_id = aws_security_group.eks_cluster.id
  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = 0
  type              = "egress"
}


# EKS Node Security Group
resource "aws_security_group" "eks_nodes" {
  name        = "${var.project}-node-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.this.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                           = "${var.project}-node-sg"
    "kubernetes.io/cluster/${var.project}-cluster" = "owned"
  }
}

resource "aws_security_group_rule" "nodes_internal" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "nodes_cluster_inbound" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 0
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_cluster.id
  to_port                  = 65535
  type                     = "ingress"
}

# Added for testing
resource "aws_security_group_rule" "nodes_ssh" {
  description       = "SSH into node"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_nodes.id
  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = 22
  type              = "ingress"
}
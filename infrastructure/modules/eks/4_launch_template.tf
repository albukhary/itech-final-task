resource "aws_launch_template" "example" {
  name_prefix            = "example"
  instance_type          = var.instance_type
  image_id               = data.aws_ssm_parameter.cluster.value
  key_name               = var.key_name
  update_default_version = true


  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.ebs_volume_size
    }
  }

  vpc_security_group_ids = [
    var.eks_nodes_sg_id,
  ]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name                                                        = var.node_name
      "kubernetes.io/cluster/${aws_eks_cluster.eks-cluster.name}" = "owned"
    }
  }
  user_data = base64encode(templatefile("${path.module}/data/userdata.tpl", { CLUSTER_NAME = aws_eks_cluster.eks-cluster.name, B64_CLUSTER_CA = aws_eks_cluster.eks-cluster.certificate_authority[0].data, API_SERVER_URL = aws_eks_cluster.eks-cluster.endpoint }))
}


data "aws_ssm_parameter" "cluster" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.eks-cluster.version}/amazon-linux-2/recommended/image_id"
}
variable "public_subnets_id" {
  description = "List of Public subnets EKS cluster operates in"
  type        = list(string)
}

variable "private_subnets_id" {
  description = "List of Private subnets EKS cluster operates in"
  type        = list(string)
}

variable "eks_cluster_sg_id" {
  description = "ID of Security group for control plane"
  type        = string
}

variable "eks_nodes_sg_id" {
  description = "ID of Security group for nodes"
  type        = string
}

variable "cluster_name" {
  description = "Name for the EKS cluster"
  type        = string
  default     = ""
}

variable "nodegroup_name" {
  description = "Name of the EKS nodegroup"
  type        = string
  default     = "t2_micro-node_group"
}

###### Varibles for Nodegroup nodes
variable "node_name" {
  description = "Name of the EC2 instance"
  type        = string
  default     = "EKS-Node"
}

variable "ami_id" {
  description = "ID of the AMI used by the nodes"
  type        = string
  default     = "ami-005f9685cb30f234b"
}

variable "instance_type" {
  description = "Type of node"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the ssh Key-pair"
  type        = string
  default     = "itech-aws"
}

variable "ebs_volume_size" {
  description = "Size of the EBS Volume to be attached to the node"
  type        = number
  default     = 8
}
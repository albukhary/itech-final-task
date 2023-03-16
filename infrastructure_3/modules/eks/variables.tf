variable "public_subnets_id" {
  description = "List of Public subnets EKS cluster operates in"
  type = list(string)
}

variable "private_subnets_id" {
  description = "List of Private subnets EKS cluster operates in"
  type = list(string)
}

variable "security_groups_id" {
  description = "List of Security Group IDs that will be used within the cluster"
  type = list(string)
}

variable "cluster_name" {
  description = "Name for the EKS cluster"
  type = string
  default = ""
}

variable "nodegroup_name" {
  description = "Name of the EKS nodegroup"
  type = string
  default = "t2_micro-node_group"
}
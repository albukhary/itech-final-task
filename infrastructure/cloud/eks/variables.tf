variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "iTech-final-task"
}

variable "cluster_name" {
  description = "Name for the EKS cluster"
  type        = string
  default     = "cluster"
}

variable "nodegroup_name" {
  description = "Name of the EKS nodegroup"
  type        = string
  default     = "iTech-final-task-node_group"
}
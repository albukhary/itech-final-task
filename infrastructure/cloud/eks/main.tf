terraform {
  backend "s3" {
    bucket         = "itech-final-state"
    key            = "us-east-1/eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "itech-final-tfstate-lock"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.53.0"
    }
  }
  required_version = ">= 1.0.2"
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      "Environment" = "Development"
      "Team"        = "iTech-DevOps"
      "DevelopedBy" = "Terraform"
      "Application" = "iTech-final-task"
      "OwnerEmail"  = "lazizbekexclusive@gmail.com"
    }
  }
}


data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "itech-final-state"
    key    = "us-east-1/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}


module "eks" {
  source             = "../../modules/eks"
  public_subnets_id  = data.terraform_remote_state.vpc.outputs.public_subnets_id
  private_subnets_id = data.terraform_remote_state.vpc.outputs.private_subnets_id

  eks_cluster_sg_id = data.terraform_remote_state.vpc.outputs.eks_cluster_sg_id
  eks_nodes_sg_id   = data.terraform_remote_state.vpc.outputs.eks_nodes_sg_id

  cluster_name   = "${var.project_name}-${var.cluster_name}"
  nodegroup_name = "${var.project_name}-${var.nodegroup_name}"
}
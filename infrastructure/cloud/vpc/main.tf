terraform {
  backend "s3" {
    bucket         = "itech-final-state"
    key            = "us-east-1/vpc/terraform.tfstate"
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
  region = var.aws_region
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


module "vpc" {
  source = "../../modules/vpc"
}
terraform {
  backend "s3" {
    bucket         = "itech-final-state"
    dynamodb_table = "itech-final-tfstate-lock"
    key            = "itech-final-task.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

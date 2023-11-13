provider "aws" {
  region     = var.region
}


terraform {
  backend "s3" {

    bucket  = "main-project-bucket"
    key     = "bookstore/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
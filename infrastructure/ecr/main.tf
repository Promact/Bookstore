provider "aws" {
  region = "eu-north-1"  
}

resource "aws_ecr_repository" "this" {
  name                 = "myrepo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repository_url" {
    value = aws_ecr_repository.this.repository_url
}


# resource "aws_instance" "example" {
#   ami           = "ami-0fe8bec493a81c7da"
#   instance_type = "t3.micro"
# }
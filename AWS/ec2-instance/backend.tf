terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# terraform {
#   backend "s3" {
#     bucket = "tf-state-12345"
#     key    = "ec2-template/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

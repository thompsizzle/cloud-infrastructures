terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# terraform {
#   backend "s3" {
#     bucket = "REPLACE_ME"
#     key    = "ec2-instance-template/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

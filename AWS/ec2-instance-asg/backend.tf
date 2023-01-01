terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# terraform {
#   backend "s3" {
#     bucket = "tf-state-26004"
#     key    = "ec2-instance-asg-template/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

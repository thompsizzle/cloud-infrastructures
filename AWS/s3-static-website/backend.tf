terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# terraform {
#   backend "s3" {
#     bucket = "REPLACE_ME"
#     key    = "s3-static-website-template/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

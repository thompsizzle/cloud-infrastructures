# Create VPC
resource "aws_vpc" "otis_vpc" {
  cidr_block                       = "10.17.0.0/16"
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "otis-vpc"
  }
}

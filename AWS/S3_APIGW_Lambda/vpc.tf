# Create VPC
resource "aws_vpc" "vpc_tf" {
  cidr_block                       = var.address_space
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "vpc-tf"
  }
}

# Public web subnet in AZ A
resource "aws_subnet" "sn_web_a_tf" {
  vpc_id                  = aws_vpc.vpc_tf.id
  cidr_block              = cidrsubnet(var.address_space, 4, 0)
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true

  tags = {
    Name = "sn-web-a-tf"
  }
}

# Private app subnet in AZ A
resource "aws_subnet" "sn_app_a_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = cidrsubnet(var.address_space, 4, 1)
  availability_zone = var.availability_zone_1

  tags = {
    Name = "sn-app-a-tf"
  }
}

# Private db subnet in AZ A
resource "aws_subnet" "sn_db_a_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = cidrsubnet(var.address_space, 4, 2)
  availability_zone = var.availability_zone_1

  tags = {
    Name = "sn-db-a-tf"
  }
}

# Private reserved subnet in AZ A
resource "aws_subnet" "sn_reserved_a_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = cidrsubnet(var.address_space, 4, 3)
  availability_zone = var.availability_zone_1

  tags = {
    Name = "sn-reserved-a-tf"
  }
}

# Public web subnet in AZ B
resource "aws_subnet" "sn_web_b_tf" {
  vpc_id                  = aws_vpc.vpc_tf.id
  cidr_block              = cidrsubnet(var.address_space, 4, 4)
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

  tags = {
    Name = "sn-web-b-tf"
  }
}

# Private app subnet in AZ B
resource "aws_subnet" "sn_app_b_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = cidrsubnet(var.address_space, 4, 5)
  availability_zone = var.availability_zone_2

  tags = {
    Name = "sn-app-b-tf"
  }
}

# Private db subnet in AZ B
resource "aws_subnet" "sn_db_b_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = cidrsubnet(var.address_space, 4, 6)
  availability_zone = var.availability_zone_2

  tags = {
    Name = "sn-db-b-tf"
  }
}

# Private reserved subnet in AZ B
resource "aws_subnet" "sn_reserved_b_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = cidrsubnet(var.address_space, 4, 7)
  availability_zone = var.availability_zone_2

  tags = {
    Name = "sn-reserved-b-tf"
  }
}

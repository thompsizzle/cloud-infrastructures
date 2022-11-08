# Create VPC
resource "aws_vpc" "vpc_tf" {
  cidr_block                       = "10.17.0.0/16"
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "vpc-tf"
  }
}

# Public web subnet in AZ A
resource "aws_subnet" "sn_web_a_tf" {
  vpc_id                  = aws_vpc.vpc_tf.id
  cidr_block              = "10.17.0.0/20"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "sn-web-a-tf"
  }
}

# Private app subnet in AZ A
resource "aws_subnet" "sn_app_a_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = "10.17.16.0/20"
  availability_zone = "us-east-1a"

  tags = {
    Name = "sn-app-a-tf"
  }
}

# Private db subnet in AZ A
resource "aws_subnet" "sn_db_a_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = "10.17.32.0/20"
  availability_zone = "us-east-1a"

  tags = {
    Name = "sn-db-a-tf"
  }
}

# Private reserved subnet in AZ A
resource "aws_subnet" "sn_reserved_a_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = "10.17.48.0/20"
  availability_zone = "us-east-1a"

  tags = {
    Name = "sn-reserved-a-tf"
  }
}

# Public web subnet in AZ B
resource "aws_subnet" "sn_web_b_tf" {
  vpc_id                  = aws_vpc.vpc_tf.id
  cidr_block              = "10.17.64.0/20"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "sn-web-b-tf"
  }
}

# Private app subnet in AZ B
resource "aws_subnet" "sn_app_b_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = "10.17.80.0/20"
  availability_zone = "us-east-1b"

  tags = {
    Name = "sn-app-b-tf"
  }
}

# Private db subnet in AZ B
resource "aws_subnet" "sn_db_b_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = "10.17.96.0/20"
  availability_zone = "us-east-1b"

  tags = {
    Name = "sn-db-b-tf"
  }
}

# Private reserved subnet in AZ B
resource "aws_subnet" "sn_reserved_b_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = "10.17.112.0/20"
  availability_zone = "us-east-1b"

  tags = {
    Name = "sn-reserved-b-tf"
  }
}

# Internet gateway attached to new VPC
resource "aws_internet_gateway" "vpc_igw_tf" {
  vpc_id = aws_vpc.vpc_tf.id

  tags = {
    Name = "vpc-igw-tf"
  }
}

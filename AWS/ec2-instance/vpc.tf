resource "aws_vpc" "vpc_tf" {
  cidr_block                       = var.address_space
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = true

  tags = local.common_tags
}

resource "aws_subnet" "sn_web_a_tf" {
  vpc_id                  = aws_vpc.vpc_tf.id
  cidr_block              = cidrsubnet(var.address_space, 4, 0)
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true

  tags = local.common_tags
}

resource "aws_subnet" "sn_app_a_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = cidrsubnet(var.address_space, 4, 1)
  availability_zone = var.availability_zone_1

  tags = local.common_tags
}

resource "aws_subnet" "sn_db_a_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = cidrsubnet(var.address_space, 4, 2)
  availability_zone = var.availability_zone_1

  tags = local.common_tags
}

resource "aws_subnet" "sn_reserved_a_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = cidrsubnet(var.address_space, 4, 3)
  availability_zone = var.availability_zone_1

  tags = local.common_tags
}

resource "aws_subnet" "sn_web_b_tf" {
  vpc_id                  = aws_vpc.vpc_tf.id
  cidr_block              = cidrsubnet(var.address_space, 4, 4)
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

  tags = local.common_tags
}

resource "aws_subnet" "sn_app_b_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = cidrsubnet(var.address_space, 4, 5)
  availability_zone = var.availability_zone_2

  tags = local.common_tags
}

resource "aws_subnet" "sn_db_b_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = cidrsubnet(var.address_space, 4, 6)
  availability_zone = var.availability_zone_2

  tags = local.common_tags
}

resource "aws_subnet" "sn_reserved_b_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = cidrsubnet(var.address_space, 4, 7)
  availability_zone = var.availability_zone_2

  tags = local.common_tags
}

resource "aws_internet_gateway" "vpc_igw_tf" {
  vpc_id = aws_vpc.vpc_tf.id

  tags = local.common_tags
}

resource "aws_route_table" "rt_web_igw_tf" {
  vpc_id = aws_vpc.vpc_tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw_tf.id
  }

  tags = local.common_tags
}

resource "aws_route_table_association" "rt_associate_web_a_tf" {
  subnet_id      = aws_subnet.sn_web_a_tf.id
  route_table_id = aws_route_table.rt_web_igw_tf.id
}

resource "aws_route_table_association" "rt_associate_web_b_tf" {
  subnet_id      = aws_subnet.sn_web_b_tf.id
  route_table_id = aws_route_table.rt_web_igw_tf.id
}

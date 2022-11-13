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

# Internet gateway attached to new VPC
resource "aws_internet_gateway" "vpc_igw_tf" {
  vpc_id = aws_vpc.vpc_tf.id

  tags = {
    Name = "vpc-igw-tf"
  }
}

# Security group to access instances inside the public subnets using HTTP
resource "aws_security_group" "ec2_public_access_tf" {
  name        = "EC2PublicAccessTF"
  description = "Allow HTTP inbound"
  vpc_id      = aws_vpc.vpc_tf.id

  ingress {
    description = "SSH from all IPv4"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTPS to VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "ec2_ssh_key_tf" {
  key_name   = "ssh-key-tf"
  public_key = file("ssh-key-tf.pub")
}

# Route table for web subnets
resource "aws_route_table" "rt_web_igw_tf" {
  vpc_id = aws_vpc.vpc_tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw_tf.id
  }

  tags = {
    Name = "rt-web-igw-tf"
  }
}

# Associate route table with web a subnet
resource "aws_route_table_association" "rt_associate_web_a_tf" {
  subnet_id      = aws_subnet.sn_web_a_tf.id
  route_table_id = aws_route_table.rt_web_igw_tf.id
}

# Associate route table with web b subnet
resource "aws_route_table_association" "rt_associate_web_b_tf" {
  subnet_id      = aws_subnet.sn_web_b_tf.id
  route_table_id = aws_route_table.rt_web_igw_tf.id
}

resource "aws_network_interface" "eni_a_tf" {
  subnet_id       = aws_subnet.sn_web_a_tf.id
  private_ips     = ["10.17.0.100"]
  security_groups = [aws_security_group.ec2_public_access_tf.id]

  tags = {
    Name = "ec2-web-a-eni-tf"
  }
}

resource "aws_instance" "ec2_tf" {
  ami           = lookup(var.aws_amis, var.aws_region)
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.ec2_ssh_key_tf.key_name

  network_interface {
    network_interface_id = aws_network_interface.eni_a_tf.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  monitoring = var.ec2_instance_monitoring

}

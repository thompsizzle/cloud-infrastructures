resource "aws_vpc" "vpc_tf" {
  cidr_block                       = var.address_space
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "vpc-tf"
  }
}

resource "aws_subnet" "sn_web_a_tf" {
  vpc_id                  = aws_vpc.vpc_tf.id
  cidr_block              = cidrsubnet(var.address_space, 4, 0)
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true

  tags = {
    Name = "sn-web-a-tf"
  }
}

resource "aws_subnet" "sn_app_a_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = cidrsubnet(var.address_space, 4, 1)
  availability_zone = var.availability_zone_1

  tags = {
    Name = "sn-app-a-tf"
  }
}

resource "aws_subnet" "sn_db_a_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = cidrsubnet(var.address_space, 4, 2)
  availability_zone = var.availability_zone_1

  tags = {
    Name = "sn-db-a-tf"
  }
}

resource "aws_subnet" "sn_reserved_a_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = cidrsubnet(var.address_space, 4, 3)
  availability_zone = var.availability_zone_1

  tags = {
    Name = "sn-reserved-a-tf"
  }
}

resource "aws_subnet" "sn_web_b_tf" {
  vpc_id                  = aws_vpc.vpc_tf.id
  cidr_block              = cidrsubnet(var.address_space, 4, 4)
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

  tags = {
    Name = "sn-web-b-tf"
  }
}

resource "aws_subnet" "sn_app_b_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = cidrsubnet(var.address_space, 4, 5)
  availability_zone = var.availability_zone_2

  tags = {
    Name = "sn-app-b-tf"
  }
}

resource "aws_subnet" "sn_db_b_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = cidrsubnet(var.address_space, 4, 6)
  availability_zone = var.availability_zone_2

  tags = {
    Name = "sn-db-b-tf"
  }
}

resource "aws_subnet" "sn_reserved_b_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = cidrsubnet(var.address_space, 4, 7)
  availability_zone = var.availability_zone_2

  tags = {
    Name = "sn-reserved-b-tf"
  }
}

resource "aws_internet_gateway" "vpc_igw_tf" {
  vpc_id = aws_vpc.vpc_tf.id

  tags = {
    Name = "vpc-igw-tf"
  }
}

resource "aws_security_group" "ec2_public_access_tf" {
  name        = "EC2PublicAccessTF"
  description = "Allow HTTP inbound"
  vpc_id      = aws_vpc.vpc_tf.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTP to VPC"
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

resource "aws_route_table_association" "rt_associate_web_a_tf" {
  subnet_id      = aws_subnet.sn_web_a_tf.id
  route_table_id = aws_route_table.rt_web_igw_tf.id
}

resource "aws_route_table_association" "rt_associate_web_b_tf" {
  subnet_id      = aws_subnet.sn_web_b_tf.id
  route_table_id = aws_route_table.rt_web_igw_tf.id
}

resource "aws_s3_bucket" "bucket_logs_tf" {
  bucket        = "ec2-hello-world-asg-logs-tf"
  force_destroy = true

  tags = {
    Name = "Logs Bucket TF"
  }
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.bucket_logs_tf.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.bucket_logs_tf.bucket
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "allow_access_from_another_account" {

  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${lookup(var.aws_elb_account_id, var.aws_region)}:root"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.bucket_logs_tf.arn}/*",
    ]
  }
}

resource "aws_launch_template" "lt_tf" {
  name          = "lt-tf"
  image_id      = lookup(var.aws_amis, var.aws_region)
  instance_type = var.ec2_instance_type

  network_interfaces {
    description = "public-network-interface-tf"
    security_groups = [
      aws_security_group.ec2_public_access_tf.id
    ]
  }

  monitoring {
    enabled = var.ec2_instance_monitoring
  }

  tags = {
    Name = "launch-template-tf"
  }

  user_data = filebase64("user_data.tftpl")
}

resource "aws_lb_target_group" "lb_tg_tf" {
  name     = "lb-tg-tf"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_tf.id
}

resource "aws_lb" "lb_tf" {
  name               = "lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.ec2_public_access_tf.id
  ]
  subnets = [
    aws_subnet.sn_web_a_tf.id,
    aws_subnet.sn_web_b_tf.id
  ]

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.bucket_logs_tf.bucket
    enabled = true
  }
}

resource "aws_lb_listener" "lb_listener_tf" {
  load_balancer_arn = aws_lb.lb_tf.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg_tf.arn
  }
}

resource "aws_autoscaling_group" "asg_tf" {
  name = "asg-tf"
  vpc_zone_identifier = [
    aws_subnet.sn_web_a_tf.id,
    aws_subnet.sn_web_b_tf.id
  ]
  max_size         = 2
  min_size         = 1
  desired_capacity = 2

  launch_template {
    id      = aws_launch_template.lt_tf.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.lb_tg_tf.arn
  ]
}

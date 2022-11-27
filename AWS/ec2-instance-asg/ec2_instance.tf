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

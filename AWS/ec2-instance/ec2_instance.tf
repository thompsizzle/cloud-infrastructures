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

resource "aws_network_interface" "eni_a_tf" {
  subnet_id       = aws_subnet.sn_web_a_tf.id
  private_ips     = ["10.17.0.100"]
  security_groups = [aws_security_group.ec2_public_access_tf.id]

  tags = local.common_tags
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

  user_data = templatefile("user_data.tftpl", {})

  tags = local.common_tags
}

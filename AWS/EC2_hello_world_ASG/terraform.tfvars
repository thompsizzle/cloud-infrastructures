aws_region          = "us-east-1"
address_space       = "10.17.0.0/16"
availability_zone_1 = "us-east-1a"
availability_zone_2 = "us-east-1b"
aws_amis = {
  "us-east-1" = "ami-0cff7528ff583bf9a"
  "us-east-2" = "ami-0ebc8f6f580a04647"
  "us-west-1" = "ami-008b09448b998a562"
  "us-west-2" = "ami-008b09448b998a562"
}
ec2_instance_type       = "t2.micro"
ec2_instance_monitoring = false

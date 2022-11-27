variable "aws_region" {
  description = "AWS region to launch infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "address_space" {
  description = "CIDR for VPC"
  type        = string
  default     = "10.17.0.0/16"
}

variable "availability_zone_1" {
  description = "Availability Zone within region"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_2" {
  description = "Availability Zone within region"
  type        = string
  default     = "us-east-1b"
}

variable "aws_amis" {
  description = "A map of region-specific AMI IDs"
  type        = map(any)
  default = {
    "us-east-1" = "ami-0cff7528ff583bf9a"
    "us-east-2" = "ami-0ebc8f6f580a04647"
    "us-west-1" = "ami-008b09448b998a562"
    "us-west-2" = "ami-008b09448b998a562"
  }
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ec2_instance_monitoring" {
  description = "Enable enhanced monitoring ($2.10/instance/month)"
  type        = bool
  default     = false
}

variable "aws_elb_account_id" {
  description = "Map of AWS accounts for Elastic Load Balancing for regions in U.S."
  type        = map(any)
  default = {
    "us-east-1" = "127311923021"
    "us-east-2" = "033677994240"
    "us-west-1" = "027434742980"
    "us-west-2" = "797873946194"
  }
}

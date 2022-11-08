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
}

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

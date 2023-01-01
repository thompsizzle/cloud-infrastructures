variable "aws_region" {
  description = "AWS region to launch infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket" {
  description = "Name of S3 bucket to host static website"
  type        = string
}

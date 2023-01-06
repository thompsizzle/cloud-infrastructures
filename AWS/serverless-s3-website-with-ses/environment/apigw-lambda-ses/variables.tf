variable "aws_region" {
  description = "AWS region to launch infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Domain name e.g. helloworld.com"
  type        = string
}

variable "email_address" {
  description = "Email address to use as SES identity"
  type        = string
}

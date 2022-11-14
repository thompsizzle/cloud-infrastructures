output "s3_static_website_endpoint" {
  value = "http://${var.s3_bucket}.s3-website-${var.aws_region}.amazonaws.com"
}

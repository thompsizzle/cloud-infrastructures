output "s3_static_website_endpoint" {
  value = aws_s3_bucket_website_configuration.bucket_config_tf.website_endpoint
}

output "distribution_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

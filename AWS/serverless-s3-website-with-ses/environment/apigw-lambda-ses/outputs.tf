output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = module.lambda_function.lambda_function_arn
}

output "lambda_function_invoke_arn" {
  description = "The Invoke ARN of the Lambda Function"
  value       = module.lambda_function.lambda_function_invoke_arn
}

output "s3_static_website_endpoint" {
  value = aws_s3_bucket_website_configuration.bucket_config_tf.website_endpoint
}

output "distribution_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

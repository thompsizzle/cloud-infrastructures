output "s3_static_website_endpoint" {
  value = "http://${aws_s3_bucket.bucket_tf.website_endpoint}"
}

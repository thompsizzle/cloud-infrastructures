output "load_balancer_dns" {
  value = aws_lb.lb_tf.dns_name
}

output "state_bucket_id" {
  value = aws_s3_bucket.bucket_tf.id
}

output "lb_logs_bucket_id" {
  value = aws_s3_bucket.bucket_logs_tf.id
}


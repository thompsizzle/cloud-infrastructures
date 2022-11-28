output "public_ip" {
  value = aws_instance.ec2_tf.public_ip
}

output "state_bucket_id" {
  value = aws_s3_bucket.bucket_tf.id
}

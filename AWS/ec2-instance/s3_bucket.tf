resource "aws_s3_bucket" "bucket_tf" {
  bucket        = var.s3_state_bucket
  force_destroy = true

  tags = local.common_tags
}

resource "aws_s3_bucket_versioning" "versioning_tf" {
  bucket = aws_s3_bucket.bucket_tf.id
  versioning_configuration {
    status = "Enabled"
  }
}

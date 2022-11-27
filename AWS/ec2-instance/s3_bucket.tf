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

resource "aws_s3_bucket_public_access_block" "private_tf" {
  bucket = aws_s3_bucket.bucket_tf.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "bucket_logs_tf" {
  bucket        = "ec2-hello-world-asg-logs-tf"
  force_destroy = true

  tags = local.common_tags
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket_logs_tf.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_policy" "allow_access_from_only_elb" {
  bucket = aws_s3_bucket.bucket_logs_tf.bucket
  policy = data.aws_iam_policy_document.allow_access_from_only_elb.json
}

resource "aws_s3_bucket" "bucket_tf" {
  bucket        = "tf-state-${random_integer.bucket.result}"
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

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.bucket_tf.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

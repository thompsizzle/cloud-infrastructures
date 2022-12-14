resource "aws_s3_bucket" "bucket_tf" {
  bucket = var.s3_bucket

  tags = {
    Name = "hello-world-tf"
  }
}

resource "aws_s3_bucket_website_configuration" "bucket_config_tf" {
  bucket = aws_s3_bucket.bucket_tf.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy_tf" {
  bucket = aws_s3_bucket.bucket_tf.bucket
  policy = data.aws_iam_policy_document.iam_policy_tf.json
}

resource "aws_s3_bucket_versioning" "versioning_tf" {
  bucket = aws_s3_bucket.bucket_tf.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "object_index_html" {
  bucket       = aws_s3_bucket.bucket_tf.bucket
  key          = "index.html"
  source       = "bucket_objects/index.html"
  content_type = "text/html"

  etag = filemd5("bucket_objects/index.html")
}

resource "aws_s3_object" "object_error_html" {
  bucket       = aws_s3_bucket.bucket_tf.bucket
  key          = "error.html"
  source       = "bucket_objects/error.html"
  content_type = "text/html"

  etag = filemd5("bucket_objects/error.html")
}

resource "aws_s3_object" "object_index_js" {
  bucket       = aws_s3_bucket.bucket_tf.bucket
  key          = "js/index.js"
  source       = "bucket_objects/js/index.js"
  content_type = "application/x-javascript"

  etag = filemd5("bucket_objects/js/index.js")
}

resource "aws_s3_object" "object_aws_sdk_js" {
  bucket       = aws_s3_bucket.bucket_tf.bucket
  key          = "js/aws-sdk-2.1256.0.min.js"
  source       = "bucket_objects/js/aws-sdk-2.1256.0.min.js"
  content_type = "application/x-javascript"

  etag = filemd5("bucket_objects/js/aws-sdk-2.1256.0.min.js")
}

resource "aws_s3_bucket" "state_bucket_tf" {
  bucket        = "tf-state-${random_integer.bucket.result}"
  force_destroy = true

  tags = local.common_tags
}

resource "aws_s3_bucket_versioning" "state_versioning_tf" {
  bucket = aws_s3_bucket.state_bucket_tf.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "private_tf" {
  bucket = aws_s3_bucket.state_bucket_tf.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.state_bucket_tf.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

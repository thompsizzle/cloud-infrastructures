# Create S3 bucket
resource "aws_s3_bucket" "bucket_tf" {
  bucket = var.s3_bucket

  tags = {
    Name = "hello-world-tf"
  }
}

# Bucket static website configuration resource
resource "aws_s3_bucket_website_configuration" "bucket_config_tf" {
  bucket = aws_s3_bucket.bucket_tf.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Bucket policy resource
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.bucket_tf.bucket
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

# Enable object versioning
resource "aws_s3_bucket_versioning" "versioning_tf" {
  bucket = aws_s3_bucket.bucket_tf.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket policy document
data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.bucket_tf.arn}/*",
    ]
  }
}

# Add object to bucket - index.html
resource "aws_s3_object" "object_index" {
  bucket       = aws_s3_bucket.bucket_tf.bucket
  key          = "index.html"
  source       = "bucket_objects/index.html"
  content_type = "text/html"

  etag = filemd5("bucket_objects/index.html")
}

# Add object to bucket - error.html
resource "aws_s3_object" "object_error" {
  bucket       = aws_s3_bucket.bucket_tf.bucket
  key          = "error.html"
  source       = "bucket_objects/error.html"
  content_type = "text/html"

  etag = filemd5("bucket_objects/error.html")
}

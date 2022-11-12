# Create S3 bucket
resource "aws_s3_bucket" "bucket_tf" {
  bucket = "my-tf-test-bucket32131"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
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

# Bucket policy document
data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.bucket_tf.arn,
      "${aws_s3_bucket.bucket_tf.arn}/*",
    ]
  }
}

# Add object to bucket
resource "aws_s3_object" "object_index" {
  bucket = aws_s3_bucket.bucket_tf.bucket
  key    = "index.html"
  source = "bucket_objects/index.html"
}

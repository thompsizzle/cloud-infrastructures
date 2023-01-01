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

resource "aws_s3_object" "object_index" {
  bucket       = aws_s3_bucket.bucket_tf.bucket
  key          = "index.html"
  source       = "bucket_objects/index.html"
  content_type = "text/html"

  etag = filemd5("bucket_objects/index.html")
}

resource "aws_s3_object" "object_error" {
  bucket       = aws_s3_bucket.bucket_tf.bucket
  key          = "error.html"
  source       = "bucket_objects/error.html"
  content_type = "text/html"

  etag = filemd5("bucket_objects/error.html")
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.bucket_tf.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cdn-oac-tf.id
    origin_id                = "myS3Origin"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"


  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myS3Origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Environment = "s3-hello-world-cdn-tf"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_control" "cdn-oac-tf" {
  name                              = "S3 Static Website CDN ${random_integer.bucket.result}"
  description                       = "Test policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
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

resource "aws_s3_bucket" "bucket_tf" {
  bucket = var.domain_name

  tags = {
    Name = "testing123"
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

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.bucket_tf.bucket
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_s3_bucket_versioning" "versioning_tf" {
  bucket = aws_s3_bucket.bucket_tf.id
  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_iam_policy_document" "this" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.bucket_tf.arn}/*",
    ]

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
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

resource "aws_s3_object" "object_main_css" {
  bucket       = aws_s3_bucket.bucket_tf.bucket
  key          = "main.css"
  source       = "bucket_objects/main.css"
  content_type = "text/css"

  etag = filemd5("bucket_objects/main.css")
}

resource "aws_s3_object" "object_main_js" {
  bucket       = aws_s3_bucket.bucket_tf.bucket
  key          = "js/main.js"
  source       = "bucket_objects/js/main.js"
  content_type = "text/js"

  etag = filemd5("bucket_objects/js/main.js")
}

resource "aws_s3_object" "object_main2_js" {
  bucket  = aws_s3_bucket.bucket_tf.bucket
  key     = "js/main2.js"
  content = "let API_ENDPOINT = '${aws_api_gateway_stage.this.invoke_url}/default'"

  content_type = "text/js"
}

resource "aws_s3_object" "object_logo_white" {
  bucket       = aws_s3_bucket.bucket_tf.bucket
  key          = "afyllc-white.png"
  source       = "bucket_objects/afyllc-white.png"
  content_type = "image/png"

  etag = filemd5("bucket_objects/afyllc-white.png")
}

resource "aws_s3_object" "object_logo_yellow" {
  bucket       = aws_s3_bucket.bucket_tf.bucket
  key          = "afyllc-yellow.png"
  source       = "bucket_objects/afyllc-yellow.png"
  content_type = "image/png"

  etag = filemd5("bucket_objects/afyllc-yellow.png")
}

resource "aws_s3_object" "object_favicon" {
  bucket       = aws_s3_bucket.bucket_tf.bucket
  key          = "favicon.png"
  source       = "bucket_objects/favicon.png"
  content_type = "image/png"

  etag = filemd5("bucket_objects/favicon.png")
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

  aliases = [var.domain_name]

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
      locations        = ["US", "CA"]
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.this.arn
    ssl_support_method  = "sni-only"
  }

  tags = {
    Environment = "s3-hello-world-cdn-tf"
  }

  depends_on = [
    aws_acm_certificate_validation.this
  ]
}

resource "aws_cloudfront_origin_access_control" "cdn-oac-tf" {
  name                              = "CDN OAC TF"
  description                       = "CDN policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = "DNS"
}

resource "aws_route53_record" "this" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.primary.zone_id
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.this : record.fqdn]
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53domains_registered_domain" "this" {
  domain_name = var.domain_name

  name_server {
    name = element(aws_route53_zone.primary.name_servers, 0)
  }

  name_server {
    name = element(aws_route53_zone.primary.name_servers, 1)
  }

  tags = {
    Environment = "test"
  }
}

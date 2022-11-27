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

data "aws_iam_policy_document" "allow_access_from_only_elb" {

  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${lookup(var.aws_elb_account_id, var.aws_region)}:root"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.bucket_logs_tf.arn}/*",
    ]
  }
}

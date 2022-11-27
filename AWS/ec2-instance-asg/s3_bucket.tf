resource "aws_s3_bucket" "bucket_logs_tf" {
  bucket        = "ec2-hello-world-asg-logs-tf"
  force_destroy = true

  tags = {
    Name = "Logs Bucket TF"
  }
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.bucket_logs_tf.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.bucket_logs_tf.bucket
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {

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
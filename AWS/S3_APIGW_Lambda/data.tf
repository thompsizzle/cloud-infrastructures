
data "aws_iam_policy_document" "iam_policy_tf" {
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

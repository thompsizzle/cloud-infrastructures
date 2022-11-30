data "aws_caller_identity" "current" {}

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

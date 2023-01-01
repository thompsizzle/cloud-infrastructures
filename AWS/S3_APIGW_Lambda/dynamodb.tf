resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "TFStateLock"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.common_tags
}

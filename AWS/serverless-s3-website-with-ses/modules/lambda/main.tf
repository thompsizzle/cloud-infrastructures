module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "4.7.1"

  function_name = var.function_name
  description   = var.description
  handler       = var.handler
  runtime       = var.runtime
  publish       = var.publish

  role_name                = var.role_name
  attach_policy_statements = var.attach_policy_statements
  policy_statements        = var.policy_statements

  source_path = var.source_path

  allowed_triggers = var.allowed_triggers
}

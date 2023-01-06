data "aws_caller_identity" "current" {}

module "lambda_function" {
  source = "../../../modules/lambda"

  function_name = "sendEmailSES"
  description   = "Send email using SES"
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  publish       = true

  attach_policy_statements = true
  policy_statements = {
    logs = {
      effect    = "Allow",
      actions   = ["logs:CreateLogGroup"],
      resources = ["arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"]
    },
    logs = {
      effect = "Allow",
      actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      resources = ["arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/sendEmailSES:*"]
    },
    ses = {
      effect = "Allow",
      actions = [
        "ses:SendEmail",
        "ses:SendRawEmail"
      ],
      resources = ["*"]
    }
  }

  source_path = "./src/lambda-function-ses"

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
    }
  }
}

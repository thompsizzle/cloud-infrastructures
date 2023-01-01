resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_tf.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.aws_region}:087563087326:${aws_api_gateway_rest_api.apigw_tf.id}/*/${aws_api_gateway_method.method_tf.http_method}${aws_api_gateway_resource.resource_tf.path}"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "tf_simple_response"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}

resource "aws_lambda_function" "lambda_tf" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_functions/app.py.zip"
  function_name = "tf_simple_response"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "app.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("lambda_functions/app.py.zip")

  runtime = "python3.9"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

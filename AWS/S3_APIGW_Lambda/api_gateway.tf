resource "aws_api_gateway_rest_api" "apigw_tf" {

  name = "example-tf"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "resource_tf" {
  path_part   = "resource"
  parent_id   = aws_api_gateway_rest_api.apigw_tf.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.apigw_tf.id
}

resource "aws_api_gateway_method" "method_tf" {
  rest_api_id   = aws_api_gateway_rest_api.apigw_tf.id
  resource_id   = aws_api_gateway_resource.resource_tf.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration_tf" {
  rest_api_id             = aws_api_gateway_rest_api.apigw_tf.id
  resource_id             = aws_api_gateway_resource.resource_tf.id
  http_method             = aws_api_gateway_method.method_tf.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_tf.invoke_arn

  depends_on = [
    aws_api_gateway_method.method_tf
  ]
}

# resource "aws_api_gateway_rest_api_policy" "apigw_policy_tf" {
#   rest_api_id = aws_api_gateway_rest_api.apigw_tf.id

#   policy = <<EOF
#   {
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Principal": {
#           "AWS": "*"
#         },
#         "Action": "execute-api:Invoke",
#         "Resource": "${aws_api_gateway_rest_api.apigw_tf.execution_arn}"
#       }
#     ]
#   }
#   EOF
# }

resource "aws_api_gateway_deployment" "deployment_tf" {
  rest_api_id = aws_api_gateway_rest_api.apigw_tf.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.resource_tf.id,
      aws_api_gateway_method.method_tf.id,
      aws_api_gateway_integration.integration_tf.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage_tf" {
  deployment_id = aws_api_gateway_deployment.deployment_tf.id
  rest_api_id   = aws_api_gateway_rest_api.apigw_tf.id
  stage_name    = "development"
}

resource "aws_ssm_parameter" "parameter_store_tf" {
  name        = "/api-gateway-invoke-url"
  description = "API Gateway invoke url"
  type        = "String"
  value       = "${aws_api_gateway_stage.stage_tf.invoke_url}${aws_api_gateway_resource.resource_tf.path}"
}

resource "aws_api_gateway_rest_api" "my_api" {
  name        = "MyAPI"
  description = "API for managing EC2 instances"
}

resource "aws_api_gateway_resource" "ec2_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "ec2"
}

resource "aws_api_gateway_resource" "create_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_resource.ec2_resource.id
  path_part   = "create"
}

resource "aws_api_gateway_resource" "start_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_resource.ec2_resource.id
  path_part   = "start"
}

resource "aws_api_gateway_resource" "stop_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_resource.ec2_resource.id
  path_part   = "stop"
}

resource "aws_api_gateway_resource" "delete_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_resource.ec2_resource.id
  path_part   = "delete"
}

resource "aws_api_gateway_method" "create_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.create_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "create_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.create_resource.id
  http_method = aws_api_gateway_method.create_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.create_lambda.invoke_arn
}

resource "aws_api_gateway_method" "start_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.start_resource.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.querystring.instance_id" = true
  }
}

resource "aws_api_gateway_integration" "start_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.start_resource.id
  http_method = aws_api_gateway_method.start_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.start_lambda.invoke_arn
  request_parameters = {
    "integration.request.querystring.instance_id" = "method.request.querystring.instance_id"
  }
}

resource "aws_api_gateway_method" "stop_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.stop_resource.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.querystring.instance_id" = true
  }
}

resource "aws_api_gateway_integration" "stop_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.stop_resource.id
  http_method = aws_api_gateway_method.stop_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.stop_lambda.invoke_arn
  request_parameters = {
    "integration.request.querystring.instance_id" = "method.request.querystring.instance_id"
  }
}

resource "aws_api_gateway_method" "delete_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.delete_resource.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.querystring.instance_id" = true
  }
}

resource "aws_api_gateway_integration" "delete_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.delete_resource.id
  http_method = aws_api_gateway_method.delete_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.delete_lambda.invoke_arn
  request_parameters = {
    "integration.request.querystring.instance_id" = "method.request.querystring.instance_id"
  }
}

resource "aws_api_gateway_deployment" "my_deployment" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = "prod"
  depends_on = [
    aws_api_gateway_integration.create_integration,
    aws_api_gateway_integration.start_integration,
    aws_api_gateway_integration.stop_integration,
    aws_api_gateway_integration.delete_integration
  ]
}
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:RunInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:TerminateInstances",
          "ec2:DescribeInstances",
          "ec2:CreateVpc",
          "ec2:CreateSubnet",
          "ec2:CreateSecurityGroup",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.lambda_exec.name
}

resource "aws_lambda_permission" "apigw_lambda_create" {
  statement_id  = "AllowExecutionFromAPIGateway-create"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "apigw_lambda_start" {
  statement_id  = "AllowExecutionFromAPIGateway-start"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "apigw_lambda_stop" {
  statement_id  = "AllowExecutionFromAPIGateway-stop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "apigw_lambda_delete" {
  statement_id  = "AllowExecutionFromAPIGateway-delete"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/*/*"
}

resource "aws_lambda_function" "create_lambda" {
  filename         = "create_lambda_function.zip"
  function_name    = "create_lambda_function"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "create_lambda_function.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = data.archive_file.create_lambda_package.output_base64sha256
  
   environment {
    variables = {
      SUBNET_ID         = aws_subnet.my_subnet.id
      SECURITY_GROUP_ID = aws_security_group.my_security_group.id
	  AMI_IMAGE_ID      = data.aws_ami.amazon_linux.id
    }
  }
}

resource "aws_lambda_function" "start_lambda" {
  filename         = "start_lambda_function.zip"
  function_name    = "start_lambda_function"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "start_lambda_function.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = data.archive_file.start_lambda_package.output_base64sha256
}

resource "aws_lambda_function" "stop_lambda" {
  filename         = "stop_lambda_function.zip"
  function_name    = "stop_lambda_function"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "stop_lambda_function.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = data.archive_file.stop_lambda_package.output_base64sha256
}

resource "aws_lambda_function" "delete_lambda" {
  filename         = "delete_lambda_function.zip"
  function_name    = "delete_lambda_function"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "delete_lambda_function.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = data.archive_file.delete_lambda_package.output_base64sha256
}

data "archive_file" "create_lambda_package" {
  type = "zip"
  source_file = "create_lambda_function.py"
  output_path = "create_lambda_function.zip"
}

data "archive_file" "start_lambda_package" {
  type = "zip"
  source_file = "start_lambda_function.py"
  output_path = "start_lambda_function.zip"
}

data "archive_file" "stop_lambda_package" {
  type = "zip"
  source_file = "stop_lambda_function.py"
  output_path = "stop_lambda_function.zip"
}

data "archive_file" "delete_lambda_package" {
  type = "zip"
  source_file = "delete_lambda_function.py"
  output_path = "delete_lambda_function.zip"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}
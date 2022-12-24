resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
    }
    EOF
}

resource "aws_lambda_function" "ping_lambda" {
  filename         = "${path.module}/lambda/ping/handler.zip"
  function_name    = "${var.ping_lambda_name}-${aws_api_gateway_stage.v1.stage_name}"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "handler/main.lambda_handler"
  memory_size      = 128
  timeout          = 60
  package_type     = "Zip"
  publish          = true
  source_code_hash = filebase64sha256("${path.module}/lambda/ping/handler.zip")

  runtime = "python3.8"
  }

  resource "aws_lambda_permission" "api_gateway_execution_permission_ping" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ping_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api-serverless.execution_arn}/*/*/*"
}

resource "aws_lambda_function" "ping_lambda-v2" {
  filename         = "${path.module}/lambda/ping-v2/handler.zip"
  function_name    = "${var.ping_lambda_name}-${aws_api_gateway_stage.v2.stage_name}"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "handler/main.lambda_handler"
  memory_size      = 128
  timeout          = 60
  package_type     = "Zip"
  publish          = true
  source_code_hash = filebase64sha256("${path.module}/lambda/ping-v2/handler.zip")

  runtime = "python3.8"
}

resource "aws_lambda_permission" "api_gateway_execution_permission_ping-v2" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ping_lambda-v2.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api-serverless.execution_arn}/*/*/*"
}
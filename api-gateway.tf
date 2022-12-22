resource "aws_api_gateway_rest_api" "api-serverless" {
  name        = "APIServerless"
  description = "Hello from Serverless API"
  body        = data.template_file.api-serverless_swagger.rendered
}

data "aws_caller_identity" "current" {}

data "template_file" "api-serverless_swagger" {
  template = file("${path.module}/openAPI.json")

  vars = {
    ping_lambda_name    = var.ping_lambda_name
    aws_region          = var.region
    aws_account_id      = data.aws_caller_identity.current.account_id
  }
}

resource "aws_api_gateway_deployment" "api-serverless-gateway-deployment" {
  rest_api_id = aws_api_gateway_rest_api.api-serverless.id
  stage_name  = "default"
}

resource "aws_api_gateway_stage" "v1" {
  deployment_id = aws_api_gateway_deployment.api-serverless-gateway-deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api-serverless.id
  stage_name    = "v1"
  variables     = {
    lambda_version = "-v1"
  }
}

resource "aws_api_gateway_stage" "v2" {
  deployment_id = aws_api_gateway_deployment.api-serverless-gateway-deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api-serverless.id
  stage_name    = "v2"
  variables     = {
    lambda_version = "-v2"
  }
}
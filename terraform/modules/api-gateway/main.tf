resource "aws_apigatewayv2_api" "this" {
  name          = "${var.project_name}-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id = aws_apigatewayv2_api.this.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.lambda_arn
}

resource "aws_apigatewayv2_route" "post" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "POST /counter"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}
resource "aws_wafv2_web_acl_association" "api" {
  resource_arn = aws_apigatewayv2_api.this.execution_arn
  web_acl_arn  = var.waf_acl_arn
}
resource "aws_lambda_permission" "api" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}

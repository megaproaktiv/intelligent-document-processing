# CloudWatch Log Groups for Lambda functions

# Log group for the Bedrock Claude3 Lambda function
resource "aws_cloudwatch_log_group" "bedrock_claude3_logs" {
  name              = "/aws/lambda/${aws_lambda_function.bedrock_claude3_lambda.function_name}"
  retention_in_days = 14
}

# Log group for the DynamoDB insertion Lambda function
resource "aws_cloudwatch_log_group" "dynamodb_insert_logs" {
  name              = "/aws/lambda/${aws_lambda_function.dynamodb_insert_lambda.function_name}"
  retention_in_days = 14
}

# Outputs for the CloudWatch Log Groups
output "bedrock_claude3_lambda_log_group" {
  description = "CloudWatch Log Group for the Bedrock Claude3 Lambda function"
  value       = aws_cloudwatch_log_group.bedrock_claude3_logs.name
}

output "dynamodb_insert_lambda_log_group" {
  description = "CloudWatch Log Group for the DynamoDB insertion Lambda function"
  value       = aws_cloudwatch_log_group.dynamodb_insert_logs.name
}

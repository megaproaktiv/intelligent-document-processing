# Outputs
output "s3_bucket_name" {
  value = aws_s3_bucket.idp_bucket.id
}

output "sqs_queue_url" {
  value = aws_sqs_queue.extracted_data_queue.url
}

output "lambda_function_name" {
  value = aws_lambda_function.bedrock_claude3_lambda.function_name
}
output "lambda2_function_name" {
  value = aws_lambda_function.dynamodb_insert_lambda.function_name
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.birth_certificates.name
  description = "Name of the DynamoDB table storing birth certificate data"
}

output "region" {
  value       = var.region
  description = "AWS region used for resources"
}

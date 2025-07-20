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

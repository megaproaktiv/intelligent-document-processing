# IAM role for the DynamoDB insertion Lambda function
resource "aws_iam_role" "dynamodb_insert_lambda_role" {
  name = "dynamodb-insert-lambda-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Policy for DynamoDB insertion Lambda to access SQS and DynamoDB
resource "aws_iam_role_policy" "dynamodb_insert_lambda_policy" {
  name = "dynamodb-insert-lambda-policy"
  role = aws_iam_role.dynamodb_insert_lambda_role.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = [aws_sqs_queue.extracted_data_queue.arn]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem"
        ]
        Resource = [aws_dynamodb_table.birth_certificates.arn]
      }
    ]
  })
}

# Basic Lambda execution policy for CloudWatch logs
resource "aws_iam_role_policy_attachment" "dynamodb_insert_lambda_basic_execution" {
  role       = aws_iam_role.dynamodb_insert_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda function for inserting data into DynamoDB
resource "aws_lambda_function" "dynamodb_insert_lambda" {
  function_name    = "insert_into_dynamodb"
  role             = aws_iam_role.dynamodb_insert_lambda_role.arn
  handler          = "lambda.insert_into_dynamodb.lambda_handler"
  runtime          = "python3.12"
  filename         = "dist/dynamodb_lambda.zip"
  source_code_hash = filebase64sha256("dist/dynamodb_lambda.zip")
  memory_size      = 128
  timeout          = 30
  
  depends_on = [
    aws_dynamodb_table.birth_certificates
  ]
}

# Event source mapping to trigger Lambda from SQS
resource "aws_lambda_event_source_mapping" "sqs_lambda_trigger" {
  event_source_arn = aws_sqs_queue.extracted_data_queue.arn
  function_name    = aws_lambda_function.dynamodb_insert_lambda.function_name
  batch_size       = 1
}

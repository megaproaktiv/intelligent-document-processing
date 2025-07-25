



# IAM role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda-bedrock-s3-sqs-role"

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

# Specific permissions policy for Lambda
resource "aws_iam_role_policy" "lambda_specific_permissions" {
  name = "SpecificPermissions"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = ["${aws_s3_bucket.idp_bucket.arn}/*"]
      },
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ]
        Resource = [
          "arn:aws:bedrock:${var.region}::foundation-model/${var.model_id}",
          "arn:aws:bedrock:${var.region}:${data.aws_caller_identity.current.account_id}:inference-profile/${var.model_id}"
        ]
      },
      {
        Effect   = "Allow"
        Action   = ["sqs:SendMessage"]
        Resource = [aws_sqs_queue.extracted_data_queue.arn]
      }
    ]
  })
}

# Basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda function
resource "aws_lambda_function" "bedrock_claude3_lambda" {
  function_name = "invoke_bedrock_claude3"
  role          = aws_iam_role.lambda_role.arn
  # the handler consists of the name of the python file without extension and the function name separated by a dot
  handler          = "invoke_bedrock_claude3.lambda_handler"
  runtime          = "python3.12"
  filename         = "dist/lambda_function.zip"
  source_code_hash = filebase64sha256("dist/lambda_function.zip")
  memory_size      = 256
  timeout          = 30

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.extracted_data_queue.url
      MODEL_ID  = var.model_id
      REGION    = var.region
    }
  }
}

# S3 bucket notification to trigger Lambda
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.idp_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.bedrock_claude3_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "images/birth_certificates/"
    filter_suffix       = ".jpeg"
  }
  depends_on = [aws_lambda_permission.allow_bucket]
}

# Permission for S3 to invoke Lambda
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.bedrock_claude3_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.idp_bucket.arn
}

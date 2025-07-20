
# SQS queue for extracted data
resource "aws_sqs_queue" "extracted_data_queue" {
  name = "bedrock-idp-extracted-data"
}

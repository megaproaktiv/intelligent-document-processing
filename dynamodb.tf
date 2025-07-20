resource "aws_dynamodb_table" "birth_certificates" {
  name           = "birth_certificates"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Id"

  attribute {
    name = "Id"
    type = "S"
  }

  tags = {
    Name        = "birth_certificates"
    Environment = "production"
  }
}

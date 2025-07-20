locals {
  suffix = var.suffix != "" ? var.suffix : data.aws_caller_identity.current.account_id
}

# S3 bucket for storing images
resource "aws_s3_bucket" "idp_bucket" {
  bucket = "bedrock-claude3-idp-${var.suffix}"
}

# Create folder structure in S3 bucket
resource "aws_s3_object" "images_folder" {
  bucket  = aws_s3_bucket.idp_bucket.id
  key     = "images/"
  content = ""
}

resource "aws_s3_object" "birth_certificates_folder" {
  bucket  = aws_s3_bucket.idp_bucket.id
  key     = "images/birth_certificates/"
  content = ""
}

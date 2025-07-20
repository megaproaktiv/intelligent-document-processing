variable "suffix" {
  type        = string
  description = "Suffix for the bucket name"
  validation {
    condition     = length(var.suffix) > 2
    error_message = "The suffix must be at least 3 characters long."
  }
}


variable "model_id" {
  type        = string
  description = "ID of the model"
  default     = "eu.anthropic.claude-3-7-sonnet-20250219-v1:0"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-central-1"
  validation {
    condition     = length(var.region) > 2
    error_message = "The suffix must be at least 3 characters long."
  }
}

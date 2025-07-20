variable "suffix" {
  type        = string
  description = "Suffix for the bucket name"
  validation {
    condition     = length(var.suffix) > 2
    error_message = "The suffix must be at least 3 characters long."
  }
}

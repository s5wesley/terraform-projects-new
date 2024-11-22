variable "bucket_name" {
  description = "The name of the S3 bucket for the backend"
  type        = string
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for state locking"
  type        = string
}

variable "force_destroy" {
  description = "Force destroy the bucket (use with caution)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
  default     = {}
}

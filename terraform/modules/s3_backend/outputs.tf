output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.backend.bucket
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  value       = aws_dynamodb_table.state_lock.name
}

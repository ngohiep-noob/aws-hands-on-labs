output "upload_bucket_name" {
  description = "Name of the upload bucket."
  value       = aws_s3_bucket.uploads.bucket
}

output "upload_prefix" {
  description = "S3 prefix watched by the lab."
  value       = local.upload_prefix
}

output "metadata_table_name" {
  description = "Name of the DynamoDB metadata table."
  value       = aws_dynamodb_table.metadata.name
}

output "lambda_function_name" {
  description = "Name of the indexing Lambda function."
  value       = aws_lambda_function.indexer.function_name
}
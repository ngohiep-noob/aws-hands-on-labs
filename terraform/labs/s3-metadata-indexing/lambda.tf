data "archive_file" "lambda_package" {
  type        = "zip"
  source_dir  = "${path.module}/../../../labs/${var.project_name}/lambda"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.project_name}-indexer-${random_id.suffix.hex}"
  retention_in_days = 7
  tags              = local.common_tags
}

resource "aws_lambda_function" "indexer" {
  function_name = "${var.project_name}-indexer-${random_id.suffix.hex}"
  role          = aws_iam_role.lambda.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.12"
  timeout       = 30
  memory_size   = 128

  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME   = aws_s3_bucket.uploads.bucket
      TABLE_NAME    = aws_dynamodb_table.metadata.name
      OBJECT_PREFIX = local.upload_prefix
    }
  }

  depends_on = [aws_cloudwatch_log_group.lambda]

  tags = merge(local.common_tags, { Name = "${var.project_name}-indexer" })
}

resource "aws_lambda_permission" "allow_s3_invocation" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.indexer.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.uploads.arn
}
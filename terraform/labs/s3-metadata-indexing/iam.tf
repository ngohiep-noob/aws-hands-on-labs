data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${var.project_name}-lambda-role-${random_id.suffix.hex}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
  tags               = merge(local.common_tags, { Name = "${var.project_name}-lambda-role" })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_logging" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "lambda_access" {
  statement {
    sid     = "ReadUploadedObjects"
    actions = ["s3:GetObject", "s3:GetObjectVersion"]
    resources = [
      aws_s3_bucket.uploads.arn,
      "${aws_s3_bucket.uploads.arn}/*",
    ]
  }

  statement {
    sid       = "WriteMetadataRecords"
    actions   = ["dynamodb:PutItem"]
    resources = [aws_dynamodb_table.metadata.arn]
  }
}

resource "aws_iam_role_policy" "lambda_access" {
  name   = "${var.project_name}-lambda-access-${random_id.suffix.hex}"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_access.json
}
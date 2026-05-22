resource "aws_dynamodb_table" "metadata" {
  name         = "${var.project_name}-metadata-${random_id.suffix.hex}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "object_key"
  range_key    = "version_id"

  attribute {
    name = "object_key"
    type = "S"
  }

  attribute {
    name = "version_id"
    type = "S"
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-metadata-table" })
}
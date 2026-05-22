locals {
  common_tags = merge(
    var.resource_tags,
    {
      Name = var.project_name
    }
  )

  upload_prefix = var.s3_object_prefix == "" ? "" : "${trimsuffix(var.s3_object_prefix, "/")}/"
}
variable "project_name" {
  description = "Project prefix for resource naming."
  type        = string
  default     = "s3-metadata-indexing"
}

variable "aws_region" {
  description = "AWS region to deploy resources."
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile name."
  type        = string
  default     = null
}

variable "s3_object_prefix" {
  description = "Only objects uploaded under this prefix are indexed."
  type        = string
  default     = "incoming/"
}

variable "resource_tags" {
  description = "Additional tags to apply to resources."
  type        = map(string)
  default = {
    Environment = "lab"
    ManagedBy   = "terraform"
  }
}
variable "project_name" {
  description = "Project prefix for resource naming."
  type        = string
  default     = "tf-dev"
}

variable "aws_region" {
  description = "AWS region to deploy resources."
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile name."
  type        = string
  default     = "default"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet."
  type        = string
  default     = "10.20.1.0/24"
}

variable "resource_tags" {
  description = "Additional tags to apply to resources."
  type        = map(string)
  default = {
    Environment = "test-dev"
    ManagedBy   = "terraform"
  }
}

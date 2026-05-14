output "vpc_id" {
  description = "ID of created VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "ID of public subnet."
  value       = aws_subnet.public.id
}

output "public_security_group_id" {
  description = "ID of public security group."
  value       = aws_security_group.public.id
}

output "artifact_bucket_name" {
  description = "Name of S3 artifact bucket."
  value       = aws_s3_bucket.artifact.bucket
}

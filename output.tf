output "primary_bucket_name" {
  description = "Name of the primary S3 bucket"

  value = aws_s3_bucket.primary.bucket
}

output "primary_bucket_arn" {
  description = "ARN of the primary S3 bucket"

  value = aws_s3_bucket.primary.arn
}

output "secondary_bucket_name" {
  description = "Name of the secondary S3 bucket"

  value = aws_s3_bucket.secondary.bucket
}

output "secondary_bucket_arn" {
  description = "ARN of the secondary S3 bucket"

  value = aws_s3_bucket.secondary.arn
}

output "replication_role_arn" {
  description = "ARN of the IAM role used by S3 replication"

  value = aws_iam_role.replication.arn
}

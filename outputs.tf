output "s3_bucket_id" {
  description = "The name of the bucket."
  value       = aws_s3_bucket.bucket.id
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.bucket.arn
}

output "s3_bucket_domain_name" {
  description = "The bucket domain name."
  value       = aws_s3_bucket.bucket.bucket_domain_name
}

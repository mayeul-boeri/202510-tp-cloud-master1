output "bucket_id" {
  value = aws_s3_bucket.app_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.app_bucket.arn
}

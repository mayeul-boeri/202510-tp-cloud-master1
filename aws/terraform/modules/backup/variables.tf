variable "project_name" {
  description = "Project name for naming"
  type        = string
}

variable "db_arn" {
  description = "ARN of the RDS instance to protect"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket to protect"
  type        = string
}

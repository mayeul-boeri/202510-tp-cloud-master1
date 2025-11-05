resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = length(var.bucket_name) > 0 ? var.bucket_name : "${var.project_name}-${random_id.bucket_suffix.hex}"

  tags = {
    Name = length(var.bucket_name) > 0 ? var.bucket_name : "${var.project_name}-${random_id.bucket_suffix.hex}"
  }
}

resource "aws_s3_bucket_acl" "app_bucket_acl" {
  count  = var.enable_acl ? 1 : 0
  bucket = aws_s3_bucket.app_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "app_bucket_versioning" {
  bucket = aws_s3_bucket.app_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_bucket_sse" {
  bucket = aws_s3_bucket.app_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "app_bucket_lifecycle" {
  bucket = aws_s3_bucket.app_bucket.id

  rule {
    id     = "keep-current"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 365
    }
  }
}

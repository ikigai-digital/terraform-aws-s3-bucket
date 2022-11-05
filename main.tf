resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  tags   = merge(var.tags, var.additional_tags)
}

resource "aws_s3_bucket_acl" "acl" {
  count = var.public_access_block_enabled == true ? 1 : 0

  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Enabled"
  }
}

resource "aws_kms_key" "key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  count = var.public_access_block_enabled == true ? 1 : 0

  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "server_access_logging" {
  count  = var.logging["enable"] ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  target_bucket = var.logging["bucket_name"]
  target_prefix = var.logging["prefix"]
}

resource "aws_s3_bucket_ownership_controls" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = var.object_ownership
  }
}


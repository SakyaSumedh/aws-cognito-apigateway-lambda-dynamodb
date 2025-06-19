resource "aws_s3_bucket" "expense-bucket" {
  count = var.create_s3 ? 1 : 0
  bucket = local.slug
}

resource "aws_s3_bucket_ownership_controls" "expense-bucket" {
  count = var.create_s3 ? 1 : 0
  bucket = aws_s3_bucket.expense-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "expense-bucket" {
  count = var.create_s3 ? 1 : 0
  depends_on = [aws_s3_bucket_ownership_controls.expense-bucket]

  bucket = aws_s3_bucket.expense-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_cors_configuration" "expense-bucket" {
  count = var.create_s3 ? 1 : 0
  bucket = aws_s3_bucket.expense-bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}
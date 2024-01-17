resource "aws_s3_bucket" "boundary_session_recording" {
  bucket        = var.s3_bucket_name
  force_destroy = true
  tags = {
    Name        = var.s3_bucket_name_tags
    Environment = var.s3_bucket_env_tags
    Terraform   = "true"
  }
}

resource "aws_s3_bucket_versioning" "versioning_demo" {
  bucket = aws_s3_bucket.boundary_session_recording.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_metric" "demo-bucket-metric" {
  bucket = aws_s3_bucket.boundary_session_recording.id
  name   = "EntireBucket"
}
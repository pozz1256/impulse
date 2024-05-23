resource "aws_s3_bucket" "tfstate_storage" {
  acl    = "private"
  bucket = "${var.global_prefix}-terraform-remote-state"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name       = "S3 Remote Terraform State Store"
    managed_by = "terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate_storage" {
  bucket = aws_s3_bucket.tfstate_storage.id

  block_public_acls       = true
  restrict_public_buckets = true
  block_public_policy     = true
  ignore_public_acls      = true
}
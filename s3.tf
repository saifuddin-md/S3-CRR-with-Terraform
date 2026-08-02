# ============================================================
# PRIMARY S3 BUCKET
# ============================================================

resource "aws_s3_bucket" "primary" {
  provider = aws.primary

  bucket = "${var.project_name}-data-${var.primary_region}"

  tags = {
    Name   = "${var.project_name}-primary"
    Region = var.primary_region
    Role   = "primary"
  }
}

# S3 Cross-Region Replication requires versioning.
resource "aws_s3_bucket_versioning" "primary" {
  provider = aws.primary

  bucket = aws_s3_bucket.primary.id

  versioning_configuration {
    status = "Enabled"
  }
}

# SSE-S3 encryption.
# Amazon S3 manages the encryption keys.
resource "aws_s3_bucket_server_side_encryption_configuration" "primary" {
  provider = aws.primary

  bucket = aws_s3_bucket.primary.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# ============================================================
# SECONDARY S3 BUCKET
# ============================================================

resource "aws_s3_bucket" "secondary" {
  provider = aws.secondary

  bucket = "${var.project_name}-data-${var.secondary_region}"

  tags = {
    Name   = "${var.project_name}-secondary"
    Region = var.secondary_region
    Role   = "secondary"
  }
}

# S3 Cross-Region Replication requires versioning.
resource "aws_s3_bucket_versioning" "secondary" {
  provider = aws.secondary

  bucket = aws_s3_bucket.secondary.id

  versioning_configuration {
    status = "Enabled"
  }
}

# SSE-S3 encryption.
# Amazon S3 manages the encryption keys.
resource "aws_s3_bucket_server_side_encryption_configuration" "secondary" {
  provider = aws.secondary

  bucket = aws_s3_bucket.secondary.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# ============================================================
# S3 CROSS-REGION REPLICATION
# PRIMARY --> SECONDARY
# ============================================================

resource "aws_s3_bucket_replication_configuration" "primary_to_secondary" {
  provider = aws.primary

  bucket = aws_s3_bucket.primary.id
  role   = aws_iam_role.replication.arn

  rule {
    id     = "replicate-all"
    status = "Enabled"

    # Empty filter means all eligible objects are replicated.
    filter {}

    destination {
      bucket        = aws_s3_bucket.secondary.arn
      storage_class = "STANDARD"
    }

    # Replicate delete markers created in the primary bucket.
    delete_marker_replication {
      status = "Enabled"
    }
  }

  # Both buckets must have versioning enabled before
  # replication can be configured.
  depends_on = [
    aws_s3_bucket_versioning.primary,
    aws_s3_bucket_versioning.secondary
  ]
}


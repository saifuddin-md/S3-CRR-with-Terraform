# ============================================================
# IAM ROLE FOR S3 REPLICATION
# ============================================================

resource "aws_iam_role" "replication" {
  provider = aws.primary

  name = "${var.project_name}-s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "s3.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}


# ============================================================
# IAM POLICY FOR S3 REPLICATION
# ============================================================

resource "aws_iam_role_policy" "replication" {
  provider = aws.primary

  name = "${var.project_name}-s3-replication-policy"
  role = aws_iam_role.replication.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      # Allow S3 to read the source bucket configuration.
      {
        Sid    = "ReadSourceBucket"
        Effect = "Allow"

        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]

        Resource = aws_s3_bucket.primary.arn
      },

      # Allow S3 to read source object versions.
      {
        Sid    = "ReadSourceObjectVersions"
        Effect = "Allow"

        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]

        Resource = "${aws_s3_bucket.primary.arn}/*"
      },

      # Allow S3 to write replicas to the destination bucket.
      {
        Sid    = "WriteDestinationReplicas"
        Effect = "Allow"

        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]

        Resource = "${aws_s3_bucket.secondary.arn}/*"
      }
    ]
  })
}
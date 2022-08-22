resource "aws_s3_bucket" "cloudfront-logs" {
  bucket = "${var.prefix}-cloudfront-logs"
}

resource "aws_s3_bucket_policy" "cloudfront-logs-policy" {
  bucket = aws_s3_bucket.cloudfront-logs.id
  policy = data.aws_iam_policy_document.cloudfront-logs-bucket-policy.json
}

resource "aws_s3_bucket_acl" "cloudfront-logs-acl" {
  bucket = aws_s3_bucket.cloudfront-logs.bucket
  access_control_policy {
    owner {
      id = data.aws_canonical_user_id.current.id
    }
    grant {
      permission = "FULL_CONTROL"
      grantee {
        id   = data.aws_canonical_user_id.current.id
        type = "CanonicalUser"
      }
    }
    grant {
      grantee {
        type = "CanonicalUser"
        id   = data.aws_cloudfront_log_delivery_canonical_user_id.current.id
      }
      permission = "FULL_CONTROL"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudfront-logs-lifecycle-configuration" {
  bucket = aws_s3_bucket.cloudfront-logs.bucket
  rule {
    id     = "log"
    status = "Enabled"

    expiration {
      days = var.cloudfront-logs-bucket-setting.rotation_days
    }
  }
}

data "aws_iam_policy_document" "cloudfront-logs-bucket-policy" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.cloudfront-logs.arn}",
      "${aws_s3_bucket.cloudfront-logs.arn}/*"
    ]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
  }
}


resource "aws_s3_bucket" "website" {
  bucket = "${var.prefix}-website"
}

resource "aws_s3_bucket_policy" "static-prod" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.static-prod-bucket-policy.json
}

resource "aws_s3_bucket_acl" "static-prod-bucket-acl" {
  bucket = aws_s3_bucket.website.bucket
  acl    = "private"
}

data "aws_iam_policy_document" "static-prod-bucket-policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]

    principals {
      identifiers = [aws_cloudfront_origin_access_identity.main.iam_arn]
      type        = "AWS"
    }
  }
}


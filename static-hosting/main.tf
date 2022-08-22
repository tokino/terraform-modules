locals {
  allow_methods_read      = ["GET", "HEAD"]
  allow_methods_read_cors = ["GET", "HEAD", "OPTIONS"]
  allow_methods_all       = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
}

data "aws_canonical_user_id" "current" {}

data "aws_cloudfront_log_delivery_canonical_user_id" "current" {}


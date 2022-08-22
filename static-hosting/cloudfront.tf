resource "aws_cloudfront_distribution" "main" {
  enabled             = true
  aliases             = var.cloudfront-aliases
  default_root_object = "index.html"
  default_cache_behavior {
    allowed_methods        = local.allow_methods_read
    cached_methods         = local.allow_methods_read
    target_origin_id       = aws_s3_bucket.website.bucket
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = var.cloudfront-default-behavior-setting.cache_policy_id

    dynamic "function_association" {
      for_each = var.cloudfront-default-behavior-setting.function_associations
      content {
        event_type   = function_association.value.event_type
        function_arn = function_association.value.function_arn
      }
    }
  }
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.website.bucket
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.cloudfront-acm-arn
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method       = "sni-only"
  }

  logging_config {
    bucket = aws_s3_bucket.cloudfront-logs.bucket_regional_domain_name
    prefix = "logs"
  }

  depends_on = [
    aws_s3_bucket.cloudfront-logs,
    aws_s3_bucket.website,
  ]
}

resource "aws_cloudfront_origin_access_identity" "main" {}
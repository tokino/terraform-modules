variable "prefix" {
  type = string
}

variable "cloudfront-aliases" {
  type = set(string)
}

variable "cloudfront-acm-arn" {
  type = string
}

variable "cloudfront-default-behavior-setting" {
  type = object({
    cache_policy_id = string
    function_associations = set(object({
      event_type   = string
      function_arn = string
    }))
  })
}

variable "cloudfront-logs-bucket-setting" {
  type = object({
    rotation_days = number
  })
}
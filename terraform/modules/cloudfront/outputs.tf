output "distribution_id" {
  value = aws_cloudfront_distribution.this.id
}

output "distribution_domain" {
  value = aws_cloudfront_distribution.this.domain_name
}
output "cloudfront_arn" {
  value = aws_cloudfront_distribution.this.arn
}
output "distribution_status" {
  value = aws_cloudfront_distribution.this.status
}

resource "aws_s3_bucket" "this" {
  bucket = "monkweb-${var.project_name}-frontend"
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id
  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_policy" "cf_access" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.this.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = var.cloudfront_arn
          }
        }
      }
    ]
  })
}

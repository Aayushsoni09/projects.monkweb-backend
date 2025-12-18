variable "project_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "acm_cert_arn" {
  type = string
}

variable "lambda_zip" {
  description = "Path to the zipped lambda function"
  type        = string
}
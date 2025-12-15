variable "project_name" {
  type = string
}

variable "scope" {
  type = string
  description = "CLOUDFRONT or REGIONAL"
}


variable "vpc_id" {
  type = string
}
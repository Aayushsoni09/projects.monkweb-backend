variable "project_name" {
  type = string
}

variable "lambda_zip" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "lambda_sg_id" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}

variable "dynamodb_table_arn" {
  type = string
}


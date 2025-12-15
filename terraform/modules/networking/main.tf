resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet("10.0.0.0/16", 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

data "aws_availability_zones" "available" {}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = aws_vpc.this.id
  service_name = "com.amazonaws.ap-south-1.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_vpc.this.main_route_table_id]
}

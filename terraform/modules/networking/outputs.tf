output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "route_table_id" {
  value = aws_vpc.this.main_route_table_id
}

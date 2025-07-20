output "main_vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnets_list" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnets_list" {
  value = aws_subnet.private_subnets[*].id
}

output "private_route_table_id" {
  value = aws_route_table.pri_route_table.id
}

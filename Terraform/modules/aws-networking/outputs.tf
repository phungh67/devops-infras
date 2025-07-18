output "main_vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnets_list" {
  value = [for s in aws_subnet.public_subnets : s.id[*]]
}

output "private_subnets_list" {
  value = [for s in aws_subnet.private_subnets: s.id[*]]
}

output "private_route_table_id" {
  value = aws_route_table.pri_route_table.id
}

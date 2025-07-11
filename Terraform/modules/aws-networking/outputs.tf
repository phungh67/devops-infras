output "main_vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnets_list" {
  value = {
    public_subets_ids = flatten([for i in aws_subnet.public_subnets[*] : i.id[*]])
  }
}

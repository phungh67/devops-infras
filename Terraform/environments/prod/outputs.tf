output "main_vpc_id" {
  value = module.aws_networking.main_vpc_id
}

output "public_subnet_ids" {
  value = module.aws_networking.public_subnets_list
}

output "bastion_sg" {
  value = module.aws_sg.bastion_sg
}

output "was_common_sg" {
  value = module.aws_sg.was_common_sg
}

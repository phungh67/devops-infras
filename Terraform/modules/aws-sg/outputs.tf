output "bastion_sg" {
  value = aws_security_group.bastion_common_sg.id
}

output "internet_allowance_sg" {
  value = aws_security_group.internet_allowance.id
}

output "was_common_sg" {
  value = aws_security_group.was_common_sg.id
}

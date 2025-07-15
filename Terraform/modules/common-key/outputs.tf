output "aws_common_key" {
  value = aws_key_pair.common-key.key_name
}

output "kms_ecs_key" {
  value = aws_kms_key.ecs-main-key.arn
}
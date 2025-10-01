output "oidc_provider" {
  value = aws_iam_openid_connect_provider.github_provider.arn
}
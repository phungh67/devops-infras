locals {
  Owner = "huyhoang.ph"
  Type  = "IaC"
}

resource "aws_iam_openid_connect_provider" "github_provider" {
  url            = var.openid_provider_url
  client_id_list = ["${var.var.openid_provider_audience}"]
  tags = {
    "Name"    = "${var.res_prefix}-openid-connect-github"
    "Service" = "CI/CD"
    "Owner"   = local.Owner
    "Type"    = local.Type
  }
}

data "template_file" "trust_policy_template_for_federated" {
  template = file("trust-policy.json")
  vars = {
    aws_account_id          = var.aws_account_id
    cloud_provider_audience = var.openid_provider_audience
    github_org              = var.github_org
    github_repo             = var.github_repo
    github_branch           = var.github_branch
  }
}

resource "aws_iam_policy" "trusted_entity_openid" {
  name = "${var.res_prefix}-trusted-policy"
  description = "Allow OpenID from GitHub to assume role"
  policy = file(data.template_file.trust_policy_template_for_federated.rendered)
}

data "aws_iam_policy" "trusted_policy" {
    arn = aws_iam_policy.trusted_entity_openid.arn
}

resource "aws_iam_role" "openid_github_role" {
  name = "${var.res_prefix}-openid-github-role"
  path = "/"
  assume_role_policy = data.aws_iam_policy.trusted_policy.policy
}

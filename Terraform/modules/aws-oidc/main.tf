locals {
  Owner = "huyhoang.ph"
  Type  = "IaC"
}

resource "aws_iam_openid_connect_provider" "github_provider" {
  url            = var.openid_provider_url
  client_id_list = ["${var.openid_provider_audience}"]
  tags = {
    "Name"    = "${var.res_prefix}-openid-connect-github"
    "Service" = "CI/CD"
    "Owner"   = local.Owner
    "Type"    = local.Type
  }
}

data "template_file" "trust_policy_template_for_federated" {
  template = file("${path.module}/trust-policy.json")
  vars = {
    aws_account_id          = var.aws_account_id
    cloud_provider_audience = var.openid_provider_audience
    github_org              = var.github_org
    github_repository       = var.github_repo
    github_branch           = var.github_branch
  }
}

# resource "aws_iam_policy" "trusted_entity_openid" {
#   name        = "${var.res_prefix}-trusted-policy"
#   description = "Allow OpenID from GitHub to assume role"
#   policy      = data.template_file.trust_policy_template_for_federated.rendered
# }

# data "aws_iam_policy" "trusted_policy" {
#   arn = aws_iam_policy.trusted_entity_openid.arn
# }

resource "aws_iam_role" "openid_github_role" {
  name               = "${var.res_prefix}-openid-github-role"
  path               = "/"
  assume_role_policy = data.template_file.trust_policy_template_for_federated.rendered
}

# attach permissions
resource "aws_iam_role_policy_attachment" "openid_attachment" {
  count      = length(var.aws_github_policy_list)
  role       = aws_iam_role.openid_github_role.name
  policy_arn = element(var.aws_github_policy_list, count.index)
}

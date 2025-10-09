variable "main_region" {
  description = "The main region to provide resources or the region which management resources are placed"
  type        = string
}

variable "aws_account_id" {
  description = "The ID of current AWS account"
  type        = string
}

variable "res_prefix" {
  description = "The prefix in resource's name to indicate environment and region"
  type        = string
}

variable "openid_provider_url" {
  description = "The URL of provider, check official documentations for accurate URL"
  type        = string
}

variable "openid_provider_audience" {
  description = "The audience - AWS service that is used to handled this provider"
  type        = string
}

variable "github_org" {
  description = "Owner of the github repository, either organization or personal"
  type        = string
}

variable "github_repo" {
  description = "Repository's name"
  type        = string
}

variable "github_branch" {
  description = "The branch to assume this role for CI/CD, each branch should have a separate IAM entity"
  type        = string
}

variable "aws_github_policy_list" {
  description = "The policies that should be attached for the GitHub role"
  type        = list(string)
}

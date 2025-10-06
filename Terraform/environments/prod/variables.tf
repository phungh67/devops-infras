variable "main_region" {
  description = "The main region to provide resources or the region which management resources are placed"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "The ID of this AWS account"
  type        = string
  default     = "713881826090"
}

variable "az_list" {
  description = "The az that are associated with the region above"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "res_prefix" {
  description = "The prefix in resource's name to indicate environment and region"
  type        = string
  default     = "due1"
}

variable "main_cidr" {
  description = "Main CIDR, assigned to the management or the main VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets_cidr" {
  description = "CIDR for several private subnets, default is a set of 3"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.21.0/24", "10.0.31.0/24"]
}

variable "public_subnets_cidr" {
  description = "CIDR for several public subnets, default is a set of 3"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
}

variable "database_subnets_cidr" {
  description = "CIDR for several database subnets, default is a set of 3"
  type        = list(string)
  default     = ["10.0.12.0/24", "10.0.22.0/24", "10.0.32.0/24"]
}

variable "default_instance_types" {
  description = "A list of instance types that can be used for computing purpose"
  type        = list(string)
  default     = ["t2.micro", "t2.small", "t2.medium"]
}

variable "openid_provider_url" {
  description = "The URL of provider, check official documentations for accurate URL"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "openid_provider_audience" {
  description = "The audience - AWS service that is used to handled this provider"
  type        = string
  default     = "sts.amazonaws.com"
}

variable "github_org" {
  description = "Owner of the github repository, either organization or personal"
  type        = string
  default     = "phungh67"
}

variable "github_repo" {
  description = "Repository's name"
  type        = string
  default     = "devops-infras"
}

variable "github_branch" {
  description = "The branch to assume this role for CI/CD, each branch should have a separate IAM entity"
  type        = string
  default     = "main"
}

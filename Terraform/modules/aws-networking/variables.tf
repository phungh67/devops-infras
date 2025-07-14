variable "res_prefix" {
  description = "The prefix in resource's name to indicate environment and region"
  type        = string
  default     = "due1"
}

variable "az_list" {
  description = "The az that are associated with the region above"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
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

variable "lb_type" {
  description = "Type of the LB to provision"
  type = list(string)
  default = [ "application", "network" ]
}

variable "default_region" {
  description = "The region of this VPC"
  type        = string
}

variable "number_of_subnets" {
  description = "The number of identical subnet that will be created for each layer"
  type        = number
}

variable "number_of_layer" {
  type        = number
  description = "Number of layers: 1 (Public), 2 (Public+Private), 3 (Public+Private+Isolated)"
}

variable "original_cidr" {
  description = "The CIDR for VPC, passed down for subnets"
  type        = string
}

variable "group_name" {
  description = "The group name for better naming"
  type        = string
}

variable "nat_attached" {
  description = "Determine if the AWS provided NAT is used"
  type        = number
}

variable "dedicated_eip_for_nat" {
  description = "Determine if want to use a dedicated EIP for NAT"
  type        = number
}
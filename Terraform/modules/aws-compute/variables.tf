variable "main_region" {
  description = "The main region to provide resources or the region which management resources are placed"
  type        = string
  default     = "us-east-1"
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

variable "instance_type_list" {
  description = "This list contains instance type for general purposes servers (t2 family, from micro to medium)"
  type        = list(string)
  default     = ["t2.micro", "t2.small", "t2.medium"]
}

variable "instance_default_ami" {
  description = "This list contains AMI used for servers. Ubuntu and Amazon Linux"
  type        = list(string)
  default     = ["ami-020cba7c55df1f615", "ami-05ffe3c48a9991133"]
}

variable "nat_instance_base_image" {
  description = "AMI which is used for NAT instance"
  type        = string
  default     = "ami-0fd5e2bb53e2a1003"
}

variable "public_subnets_list" {
  description = "The list contains ID of public subnets"
  type        = list(string)
}

variable "private_subnets_list" {
  description = "The list contains ID of private subnets"
  type        = list(string)
}

variable "common_key_name" {
  description = "The private key that used by SSH process"
  type        = string
}

variable "bastion_sg" {
  description = "Security group for bastion host"
  type        = string
}

variable "internet_allow_sg" {
  description = "Security group allows internet access"
  type        = string
}

variable "was_common_sg" {
  description = "Security group allows communication between bastion and other servers"
  type        = string
}

# for configuring NAT instance and routing for private instances
variable "private_route_table_id" {
  description = "Output from network module"
  type        = string
}

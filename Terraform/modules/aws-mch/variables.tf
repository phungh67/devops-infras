variable "res_prefix" {
  description = "The prefix in resource's name to indicate environment and region"
  type        = string
  default     = "due1"
}

variable "ami_id" {
  description = "AMI ID for the application instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the application instances"
  type        = string
  default     = "t2.micro"
}
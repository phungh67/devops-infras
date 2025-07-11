variable "main_region" {
  description = "The main region to provide resources or the region which management resources are placed"
  type        = string
  default     = "us-east-1"
}

variable "res_prefix" {
  description = "The prefix in resource's name to indicate environment and region"
  type        = string
  default     = "due1"
}

variable "rsa_bits" {
  description = "Number of RSA bits were used to create this key"
  type        = number
  default     = 4096
}

variable "algorithm" {
  description = "The algorithm used for this key pair"
  type        = string
  default     = "RSA"
}

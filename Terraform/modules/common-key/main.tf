resource "tls_private_key" "common-was-and-bastion-key" {
  algorithm = var.algorithm
  rsa_bits  = var.rsa_bits
}

resource "aws_key_pair" "common-key" {
  key_name   = "${var.res_prefix}-common-key"
  public_key = tls_private_key.common-was-and-bastion-key.public_key_pem
  tags = {
    "Name"  = "${var.res_prefix}-common-key"
    "Owner" = "huyhoang.ph"
    "Type"  = "IaC"
  }
}

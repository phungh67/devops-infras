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

resource "aws_kms_key" "ecs-main-key" {
  description             = "This key is used for data encryption within ECS scope."
  deletion_window_in_days = 7

  tags = {
    "Name"  = "${var.res_prefix}-ecs-kms-key"
    "Owner" = "huyhoang.ph"
    "Type"  = "IaC"
  }
}

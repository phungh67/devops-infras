locals {
  Owner = "huyhoang.ph"
  Type  = "IaC"
}

resource "aws_instance" "bastion_host" {
  ami             = var.instance_default_ami[0]
  instance_type   = var.instance_type_list[0]
  key_name        = var.common_key_name
  subnet_id       = var.public_subnets_list[0]
  security_groups = ["${var.bastion_sg}", "${var.internet_allow_sg}"]
  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }
  tags = {
    "key"   = "${var.res_prefix}-bastion-host"
    "Owner" = local.Owner
    "Type"  = local.Type
  }
}

resource "aws_instance" "nat_instance" {
  ami               = var.nat_instance_base_image
  instance_type     = var.instance_type_list[0]
  key_name          = var.common_key_name
  subnet_id         = var.public_subnets_list[1]
  security_groups   = ["${var.internet_allow_sg}", "${var.was_common_sg}"]
  source_dest_check = false
  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }
  tags = {
    "Name"  = "${var.res_prefix}-nat-instance"
    "Owner" = local.Owner
    "Type"  = local.Type
  }
}

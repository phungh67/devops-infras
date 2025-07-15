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

### Routing for NAT instance

resource "aws_route" "internet_private_route" {
  route_table_id         = var.private_route_table_id
  network_interface_id   = aws_instance.nat_instance.primary_network_interface_id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private_association" {
  count          = length(var.private_subnets_list)
  subnet_id      = element(var.private_subnets_list[*], count.index)
  route_table_id = var.private_route_table_id
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "${var.res_prefix}-ecs-logs"
  tags = {
    "Owner" = local.Owner
    "Type"  = local.Type
  }
}

resource "aws_ecs_cluster" "main-cluster" {
  name = "${var.res_prefix}-main-cluster"
  configuration {
    execute_command_configuration {
      kms_key_id = var.aws_kms_ecs_key
      logging    = "OVERRIDE"
      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_log_group.name
      }
    }
  }
  tags = {
    "Name"  = "${var.res_prefix}-main-cluster"
    "Owner" = local.Owner
    "Type"  = local.Type
  }
}

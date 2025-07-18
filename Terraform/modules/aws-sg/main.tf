locals {
  common_http_ports = [8080, 80, 443]
  common_protocol   = "tcp"
  ssh_port          = 22
  Owner             = "huyhoang.ph"
  Type              = "IaC"
}

resource "aws_security_group" "internet_allowance" {
  name        = "${var.res_prefix}-internet-allowances-sg"
  description = "Allow attached resources access Internet with HTTP/HTTPS ports"
  vpc_id      = var.main_vpc_id
  tags = {
    "Name"  = "${var.res_prefix}-internet-allowances-sg"
    "Owner" = local.Owner
    "Type"  = local.Type
  }
}

resource "aws_vpc_security_group_egress_rule" "internet_egress_rule" {
  count             = length(local.common_http_ports)
  security_group_id = aws_security_group.internet_allowance.id
  description       = "Allow accessible to the internet with port ${element(local.common_http_ports, count.index)}"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = element(local.common_http_ports, count.index)
  ip_protocol       = local.common_protocol
  to_port           = element(local.common_http_ports, count.index)
}

resource "aws_security_group" "bastion_common_sg" {
  name        = "${var.res_prefix}-bastion-common-sg"
  description = "Allow bastion to ssh to other machines within VPC and also allow remotely control from operators"
  vpc_id      = var.main_vpc_id
  tags = {
    "Name"  = "${var.res_prefix}-bastion-common-sg"
    "Owner" = local.Owner
    "Type"  = local.Type
  }
}

resource "aws_security_group" "was_common_sg" {
  name        = "${var.res_prefix}-was-common-sg"
  description = "Default sg attached to all web application servers (WAS)"
  vpc_id      = var.main_vpc_id
  tags = {
    "Name"  = "${var.res_prefix}-was-common-sg"
    "Owner" = local.Owner
    "Type"  = local.Type
  }
}

resource "aws_security_group" "nat_basic_sg" {
  name        = "${var.res_prefix}-nat-common-sg"
  description = "Default sg attached to NAT instance, allows port forwarding"
  vpc_id      = var.main_vpc_id
  tags = {
    "Name"  = "${var.res_prefix}-nat-common-sg"
    "Owner" = local.Owner
    "Type"  = local.Type
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_to_bastion_host" {
  security_group_id = aws_security_group.bastion_common_sg.id
  description       = "Allow remotely control from operators"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = local.ssh_port
  ip_protocol       = local.common_protocol
  to_port           = local.ssh_port
}

resource "aws_vpc_security_group_egress_rule" "ssh_from_bastion_to_was" {
  security_group_id            = aws_security_group.bastion_common_sg.id
  description                  = "Allow bastion ssh to all WAS servers"
  referenced_security_group_id = aws_security_group.was_common_sg.id
  from_port                    = local.ssh_port
  ip_protocol                  = local.common_protocol
  to_port                      = local.ssh_port
}

resource "aws_vpc_security_group_ingress_rule" "was_allowance_ssh_from_bastion" {
  security_group_id            = aws_security_group.was_common_sg.id
  description                  = "Allow SSH from bastion host"
  referenced_security_group_id = aws_security_group.bastion_common_sg.id
  from_port                    = local.ssh_port
  ip_protocol                  = local.common_protocol
  to_port                      = local.ssh_port
}

resource "aws_vpc_security_group_egress_rule" "was_outbound_to_nat_instance" {
  count                        = length(local.common_http_ports)
  security_group_id            = aws_security_group.was_common_sg.id
  description                  = "Allow traffic to be forwared to NAT instance"
  referenced_security_group_id = aws_security_group.nat_basic_sg.id
  from_port                    = element(local.common_http_ports, count.index)
  ip_protocol                  = local.common_protocol
  to_port                      = element(local.common_http_ports, count.index)
}


resource "aws_vpc_security_group_ingress_rule" "nat_accept_traffic_from_was" {
  count                        = length(local.common_http_ports)
  security_group_id            = aws_security_group.nat_basic_sg.id
  description                  = "Allow traffic from WAS to be forwared at NAT"
  referenced_security_group_id = aws_security_group.nat_basic_sg.id
  from_port                    = element(local.common_http_ports, count.index)
  ip_protocol                  = local.common_protocol
  to_port                      = element(local.common_http_ports, count.index)
}

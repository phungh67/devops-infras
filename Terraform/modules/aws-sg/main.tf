locals {
  common_http_ports = [80, 443]
  common_protocol   = "tcp"
  ssh_port          = 22
  jenkins_port     = 8080
  sql_port         = 3306
  app_cluster_port = 5000
  Owner             = "hung.nm"
  Type              = "IaC"
}

resource "aws_security_group" "internet_allowance" {
  name        = "deu1-internet-allowances-sg"
  description = "Allow attached resources access Internet with HTTP/HTTPS ports"
  vpc_id      = var.main_vpc_id
  tags = {
    "Name"  = "deu1-internet-allowances-sg"
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

resource "aws_security_group" "alb_app_sg" {
  name        = "app_cluster_port = 5000"
  description = "Allow traffic from Internet to the ALB"
  vpc_id      = var.main_vpc_id


  tags = {
    "Name"  = "app_cluster_port = 5000"
    "Owner" = local.Owner
    "Type"  = local.Type
  }
}

resource "aws_security_group" "was_common_sg" {
  name        = "deu1-was-common-sg"
  description = "Default sg attached to all web application servers (WAS)"
  vpc_id      = var.main_vpc_id
  from_port         = local.ssh_port
  ip_protocol       = local.common_protocol
  to_port           = local.ssh_port

  tags = {
    "Name"  = "deu1-was-common-sg"
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

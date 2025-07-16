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

# ALB Security Group

resource "aws_security_group" "app_alb_sg" {
  name        = "${var.res_prefix}-app-alb-sg"
  description = "ALB Security Group"
  vpc_id      = var.main_vpc_id
  tags = {
    "Name"  = "${var.res_prefix}-app-alb-sg"
    "Owner" = local.Owner
    "Type"  = local.Type
  }
}

resource "aws_vpc_security_group_ingress_rule" "internet_to_alb" {
  count             = length(local.common_http_ports)
  security_group_id = aws_security_group.app_alb_sg.id
  description       = "Allow traffic from internet to app alb"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = element(local.common_http_ports, count.index)
  ip_protocol       = local.common_protocol
  to_port           = element(local.common_http_ports, count.index)
}

resource "aws_vpc_security_group_egress_rule" "alb_to_app_cluster" {
  security_group_id            = aws_security_group.app_alb_sg.id
  description                  = "Traffic from app alb to app cluster"
  referenced_security_group_id = aws_security_group.app_cluster_sg.id
  from_port                    = local.app_cluster_port
  ip_protocol                  = local.common_protocol
  to_port                      = local.app_cluster_port
}

# App Cluster Security Group

resource "aws_security_group" "app_cluster_sg" {
  name        = "${var.res_prefix}-app-cluster-sg"
  description = "App Cluster Security Group"
  vpc_id      = var.main_vpc_id
  tags = {
    "Name"  = "${var.res_prefix}-app-cluster-sg"
    "Owner" = local.Owner
    "Type"  = local.Type
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_from_alb_to_app_cluster" {
  security_group_id            = aws_security_group.app_cluster_sg.id
  referenced_security_group_id = aws_security_group.app_alb_sg.id
  description                  = "Allow app cluster to receive traffic from ALB"
  from_port                    = local.app_cluster_port
  to_port                      = local.app_cluster_port
  ip_protocol                  = local.common_protocol
}

resource "aws_vpc_security_group_engress_rule" "app_cluster_to_mysql" {
  security_group_id            = aws_security_group.app_cluster_sg.id
  referenced_security_group_id = aws_security_group.mysql_sg.id
  description                  = "Traffic from app cluster to MySQL"
  from_port                    = local.sql_port
  to_port                      = local.sql_port
  ip_protocol                  = local.common_protocol
}

# MySQL Security Group

resource "aws_security_group" "mysql_sg" {
  name        = "${var.res_prefix}-mysql-sg"
  description = "My SQL Security Group"
  vpc_id      = var.main_vpc_id
  tags = {
    "Name"  = "${var.res_prefix}-app-alb-sg"
    "Owner" = local.Owner
    "Type"  = local.Type
  }
}

resource "aws_vpc_security_group_ingress_rule" "app_cluster_to_mysql" {
  security_group_id            = aws_security_group.mysql_sg.id
  description                  = "Allow MySQL access from app cluster"
  referenced_security_group_id = aws_security_group.app_cluster_sg.id
  from_port                    = local.sql_port
  to_port                      = local.sql_port
  ip_protocol                  = local.common_protocol
}

# Jenkin ALB Security Group

resource "aws_security_group" "jenkins_alb_sg" {
  name        = "${var.res_prefix}-jenkins-alb-sg"
  description = "Jenkins ALB Security Group"
  vpc_id      = var.main_vpc_id
  tags = {
    "Name"  = "${var.res_prefix}-jenkins-alb-sg"
    "Owner" = local.Owner
    "Type"  = local.Type
  }
}


# Jenkin Instance Security Group

resource "aws_security_group" "jenkins_instance_sg" {
  name        = "${var.res_prefix}-jenkins-instance-sg"
  description = "Jenkins Instance Security Group"
  vpc_id      = var.main_vpc_id
  tags = {
    "Name"  = "${var.res_prefix}-jenkins-instance-sg"
    "Owner" = local.Owner
    "Type"  = local.Type
  }
}
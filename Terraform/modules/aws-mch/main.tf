locals {
  Owner = "hung.nm"
  Type  = "IaC"
}

resource "aws_lb" "app_alb" {
  name               = "${var.res_prefix}-app-alb"
  internal           = false                    
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_alb_sg.id]
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id]
  idle_timeout       = 60

  tags = {
    Name = "${var.res_prefix}-app-alb"
    Owner = local.Owner
    Type  = local.Type
  }
}

resource "aws_instance" "mysql" {
  count         = var.app_instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.private_subnets[1].id
  security_groups = [aws_security_group.mysql_sg.id]

  tags = {
    Name  = "${var.res_prefix}-mysql"
    Owner = local.Owner
    Type  = local.Type
  }
}


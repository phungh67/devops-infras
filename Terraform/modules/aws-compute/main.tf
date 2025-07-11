resource "aws_instance" "bastion_host" {
  ami = var.instance_default_ami[0]

}
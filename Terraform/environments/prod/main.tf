module "aws_networking" {
  source = "../../modules/aws-networking"
  # this module will be invoke with default parameters
  # for better customization, adding variables into tfvars file and add it below this line
}

module "aws_sg" {
  source      = "../../modules/aws-sg"
  main_vpc_id = module.aws_networking.main_vpc_id
}

module "aws_common_key" {
  source = "../../modules/common-key"
}

module "aws_compute" {
  source                 = "../../modules/aws-compute"
  private_subnets_list   = module.aws_networking.private_subnets_list
  public_subnets_list    = module.aws_networking.public_subnets_list
  bastion_sg             = module.aws_sg.bastion_sg
  was_common_sg          = module.aws_sg.was_common_sg
  internet_allow_sg      = module.aws_sg.internet_allowance_sg
  common_key_name        = module.aws_common_key.aws_common_key
  private_route_table_id = module.aws_networking.private_route_table_id
}

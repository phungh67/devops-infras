module "aws_networking" {
  source = "../../modules/aws-networking"
  # this module will be invoke with default parameters
  # for better customization, adding variables into tfvars file and add it below this line
}

module "aws_sg" {
  source      = "../../modules/aws-sg"
  main_vpc_id = module.aws_networking.main_vpc_id
}
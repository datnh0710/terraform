provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
  
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.vpc.default_security_group_ids]

  tags = {
    Name = var.instance_name
  }
  
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.19.0"
    
    name = "default-vpc"
    cidr = "10.0.0.0/16"

    azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
    public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets = ["10.0.101.0/24"]
    enable_nat_gateway = true
    enable_dns_hostnames = true
  
}
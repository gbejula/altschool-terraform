# provider 

provider "aws" {
  region = var.region
}

# create vpc
module "vpc" {
  source = "../modules/vpc"
  region = var.region
  env-prefix = var.env-prefix
  vpc_cidr = var.vpc_cidr
  subnet-az1-cidr = var.subnet-az1-cidr
  subnet-az2-cidr = var.subnet-az2-cidr
  ami = var.ami
  type = var.type
  key_pair = var.key_pair
}

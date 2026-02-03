terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source             = "../../modules/vpc"
  cidr_block         = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  tags               = { Project = "tf-simple", Env = "dev" }
}

module "s3" {
  source      = "../../modules/s3"
  bucket_name = "tf-simple-${var.account_id}-dev"
  versioning  = true
  tags        = { Project = "tf-simple", Env = "dev" }
}

module "ec2" {
  source        = "../../modules/ec2"
  ami_id        = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnet_id
  vpc_id        = module.vpc.vpc_id
  ssh_cidr      = "3.108.221.177/32"
  user_data     = file("${path.module}/userdata.sh")
  tags          = { Project = "tf-simple", Env = "dev" }
}

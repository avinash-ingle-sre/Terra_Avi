terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

# १. VPC मॉड्यूल
module "vpc" {
  source              = "../../modules/vpc"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones  = ["ap-south-1a", "ap-south-1b"]
  env                 = "dev"
}

# २. S3 मॉड्यूल
module "s3" {
  source      = "../../modules/s3"
  bucket_name = "tf-simple-${var.account_id}-dev"
  versioning  = true
  tags        = { Project = "resilient-bank", Env = "dev" }
}

# ३. EC2 मॉड्यूल (फक्त एकच आणि अपडेटेड) 🚀
module "ec2" {
  source        = "../../modules/ec2"
  env           = "dev"
  ami_id        = "ami-0dee22c13ea7a9a67"
  instance_type = "t2.micro"

  # VPC मॉड्यूलमधून आलेले आउटपुट्स
  app_sg_id      = module.vpc.app_sg_id
  internal_sg_id = module.vpc.internal_sg_id
  subnet_ids     = module.vpc.public_subnet_ids

  tags = { Project = "resilient-bank", Env = "dev" }
}

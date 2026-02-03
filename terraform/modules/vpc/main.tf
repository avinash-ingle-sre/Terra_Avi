terraform {
required_providers {
aws = { source = "hashicorp/aws", version = "~> 5.0" }
}
required_version = ">= 1.5.0"
}

resource "aws_vpc" "this" {
cidr_block = var.cidr_block
tags = merge({ Name = "tf-vpc" }, var.tags)
}

resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.this.id
tags = merge({ Name = "tf-igw" }, var.tags)
}

resource "aws_subnet" "public" {
vpc_id = aws_vpc.this.id
cidr_block = var.public_subnet_cidr
map_public_ip_on_launch = true
tags = merge({ Name = "tf-public-subnet" }, var.tags)
}

resource "aws_route_table" "public" {
vpc_id = aws_vpc.this.id
tags = merge({ Name = "tf-public-rt" }, var.tags)
}

resource "aws_route" "internet" {
route_table_id = aws_route_table.public.id
destination_cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
subnet_id = aws_subnet.public.id
route_table_id = aws_route_table.public.id
}

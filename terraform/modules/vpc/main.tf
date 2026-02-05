# 1. VPC तयार करणे
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.env}-vpc"
  }
}

# 2. Internet Gateway (IGW)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}

# 3. Public Subnets (Loop वापरून)
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-public-subnet-${count.index + 1}"
  }
}

# 4. Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-public-rt"
  }
}

# 5. Route Table Association
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# 6. Web/App Security Group (बाहेरून येण्यासाठी)
resource "aws_security_group" "app_sg" {
  name        = "${var.env}-app-sg"
  description = "Allow SSH and Web traffic"
  vpc_id      = aws_vpc.main.id

  # स्वतःच्या लॅपटॉपवरून SSH करण्यासाठी
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # सुरक्षेसाठी नंतर येथे तुमचा स्वतःचा IP टाका
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.env}-app-sg" }
}

# 7. Internal Security Group (दोन सर्व्हर्स एकमेकांशी बोलण्यासाठी)
resource "aws_security_group" "internal_sg" {
  name        = "${var.env}-internal-sg"
  description = "Allow internal traffic between instances"
  vpc_id      = aws_vpc.main.id

  # App SG असलेल्या सर्व्हरकडून येणारे सर्व ट्रॅफिक अलाऊ करा
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.env}-internal-sg" }
}

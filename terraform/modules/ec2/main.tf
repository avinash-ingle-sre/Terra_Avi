# १. बँक अ‍ॅप सर्व्हर (Public Subnet मध्ये)
resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[0] # पहिल्या सबनेटचा वापर
  vpc_security_group_ids = [var.app_sg_id]   # VPC मधून आलेला SG ID

  tags = merge(var.tags, {
    Name = "${var.env}-bank-app-server"
  })
}

# २. बँक इंटरनल सर्व्हर (दुसऱ्या Subnet मध्ये)
resource "aws_instance" "internal_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[1]    # दुसऱ्या सबनेटचा वापर
  vpc_security_group_ids = [var.internal_sg_id] # VPC मधून आलेला Internal SG ID

  tags = merge(var.tags, {
    Name = "${var.env}-bank-internal-server"
  })
}

variable "ami_id" {
type = string
}

variable "instance_type" {
type = string
default = "t2.micro"
}

variable "subnet_id" {
type = string
}

variable "vpc_id" {
type = string
}

variable "ssh_cidr" {
type = string
default = "0.0.0.0/0"
}

variable "user_data" {
type = string
default = ""
}

variable "tags" {
type = map(string)
default = {}
}

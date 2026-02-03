variable "cidr_block" {
type = string
}

variable "public_subnet_cidr" {
type = string
}

variable "tags" {
type = map(string)
default = {}
}

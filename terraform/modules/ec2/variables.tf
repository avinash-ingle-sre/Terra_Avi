variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

# आपण आता 'subnet_ids' (List) वापरतोय, म्हणून जुना 'subnet_id' काढला.

variable "env" {
  type        = string
  description = "Environment name (dev/prod)"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "app_sg_id" {
  type        = string
  description = "Security Group ID for App Server"
}

variable "internal_sg_id" {
  type        = string
  description = "Security Group ID for Internal Server"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"
}

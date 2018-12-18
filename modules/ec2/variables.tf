variable "ami" {}

variable "instance_type" {
  default = "t1.micro"
}

variable "subnet_id" {}

variable "vpc_security_group_ids" {
  type = "list"
}

variable "key_name" {}
variable "count" {}

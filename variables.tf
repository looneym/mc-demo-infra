variable "shared_credentials_file" {
  default = "~/.aws/credentials"
}

variable "region" {
  default = "us-east-1"
}

variable "ssh_key_name" {
  default = "mission-control"
}

variable "cnc_hosts_count" {}
variable "prey_hosts_count" {}

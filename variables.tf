variable "shared_credentials_file" {
  default = "~/.aws/credentials"
}

variable "region" {
  default = "us-east-1"
}

variable "ssh_key_name" {
  default = "mission-control"
}

variable "demo_hosts_count" {
  default = 1
}

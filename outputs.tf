output "ssh_key_name" {
  value = "${var.ssh_key_name}"
}

output "cnc_public_ips" {
  value = "${module.cnc.instance_public_ips}"
}

output "prey_public_ips" {
  value = "${module.prey.instance_public_ips}"
}

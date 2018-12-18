output "sg_ssh_id" {
  value = "${aws_security_group.easy-ec2-allow_ssh.id}"
}

output "sg_web_id" {
  value = "${aws_security_group.easy-ec2-web_server.id}"
}

output "subnet_id" {
  value = "${aws_subnet.easy-ec2-subnet.id}"
}

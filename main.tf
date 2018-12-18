provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${var.shared_credentials_file}"
}

data "aws_ami" "docker" {
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:Name"
    values = ["docker"]
  }

  most_recent = true
}

module "network" {
  source = "./common/network"
}

module "cnc" {
  source                 = "./modules/ec2"
  ami                    = "${data.aws_ami.docker.id}"
  count                  = "${var.cnc_hosts_count}"
  subnet_id              = "${module.network.subnet_id}"
  vpc_security_group_ids = ["${module.network.sg_ssh_id}", "${module.network.sg_web_id}"]
  key_name               = "${var.ssh_key_name}"
  instance_type          = "t2.small"
}

module "prey" {
  source                 = "./modules/ec2"
  ami                    = "${data.aws_ami.docker.id}"
  count                  = "${var.prey_hosts_count}"
  subnet_id              = "${module.network.subnet_id}"
  vpc_security_group_ids = ["${module.network.sg_ssh_id}", "${module.network.sg_web_id}"]
  key_name               = "${var.ssh_key_name}"
  instance_type          = "t2.small"
}

data "template_file" "ansible_inventory_template" {
  template = "${file("${path.module}/templates/ansible_inventory")}"
  depends_on = [
    "module.cnc",
    "module.prey",
  ]
  vars {
   cnc = "${join("\n", module.cnc.instance_public_ips)}"
   prey = "${join("\n", module.prey.instance_public_ips)}"
  }
}

resource "null_resource" "ansible_inventory" {
  triggers {
    template_rendered = "${data.template_file.ansible_inventory_template.rendered}"
  }
  provisioner "local-exec" {
    command = "echo '${data.template_file.ansible_inventory_template.rendered}' > ansible_inventory.cfg"
  }
}

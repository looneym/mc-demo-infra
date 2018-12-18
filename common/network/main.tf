###############################################################
#
#  VPC
#
###############################################################

resource "aws_vpc" "easy-ec2-vpc" {
  cidr_block = "10.100.0.0/16"
}

resource "aws_route_table" "easy-ec2-rtb" {
  vpc_id = "${aws_vpc.easy-ec2-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.easy-ec2-gw.id}"
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = "${aws_vpc.easy-ec2-vpc.id}"
  route_table_id = "${aws_route_table.easy-ec2-rtb.id}"
}

resource "aws_internet_gateway" "easy-ec2-gw" {
  vpc_id = "${aws_vpc.easy-ec2-vpc.id}"
}

###############################################################
#
#  SECURITY GROUPS
#
###############################################################

resource "aws_security_group" "easy-ec2-allow_ssh" {
  name        = "allow_all"
  description = "Allow inbound SSH traffic from my IP"
  vpc_id      = "${aws_vpc.easy-ec2-vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "easy-ec2-web_server" {
  name        = "web server"
  description = "Allow HTTP and HTTPS traffic in, browser access out."
  vpc_id      = "${aws_vpc.easy-ec2-vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

###############################################################
#
#  SUBNETS
#
###############################################################

resource "aws_subnet" "easy-ec2-subnet" {
  vpc_id                  = "${aws_vpc.easy-ec2-vpc.id}"
  availability_zone       = "${var.availability_zone}"
  cidr_block              = "10.100.2.0/24"
  map_public_ip_on_launch = true
}

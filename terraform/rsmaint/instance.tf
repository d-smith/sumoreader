data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/ebs/ubuntu-trusty-14.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["paravirtual"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "t1.micro"
    tags {
        Name = "Redshift-Client"
    }
    key_name = "FidoKeyPair"
    vpc_security_group_ids = ["${var.security_group}"]
    subnet_id = "${var.subnet}"
    user_data = "${file("dbclient_setup.txt")}"
}

output "public_dns" {
    value = "${aws_instance.web.public_dns}"
}
resource "aws_security_group" "r-security-group" {
    name = "r-sg"
    description = "security group for r instance"

    ingress {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
            from_port = 8787
            to_port = 8787
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
            from_port = 3838
            to_port = 3838
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
     }

    vpc_id = "${var.vpc}"

    tags {
        Name = "api redshift dm maint security group"
    }
}


resource "aws_instance" "web" {
    ami = "ami-6869aa05"
    instance_type = "t2.medium"
    tags {
        Name = "R"
    }
    key_name = "FidoKeyPair"
    vpc_security_group_ids = ["${aws_security_group.r-security-group.id}"]
    subnet_id = "${var.subnet}"
    user_data = "${file("r_setup.txt")}"
}

output "public_dns" {
    value = "${aws_instance.web.public_dns}"
}
resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "redshift-aws-vpc"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}



resource "aws_security_group" "api-redshift-security-group" {
    name = "api-redshift-sg"
    description = "security group for api redshift cluster"

    # Firehose Ingress
    # East 52.70.63.192/27
    # Oregon 52.89.255.224/27
    # Ireland 52.19.239.192/27
    # See http://docs.aws.amazon.com/firehose/latest/dev/controlling-access.html#using-iam-rs
    ingress {
        from_port = 5439
        to_port = 5439
        protocol = "tcp"
        cidr_blocks = ["52.89.255.224/27"]
    }

    # Ingress from public VPC
    ingress {
            from_port = 5439
            to_port = 5439
            protocol = "tcp"
            cidr_blocks = ["10.0.0.0/24"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "api redshift security group"
    }
}

resource "aws_security_group" "api-redshift-dbmaint-security-group" {
    name = "api-redshift-dbmaint-sg"
    description = "security group for api redshift cluster db maint"

    ingress {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
     }

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "api redshift dm maint security group"
    }
}




/*
  Public Subnet
*/
resource "aws_subnet" "us-west-2a-public" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "us-west-2a"
    map_public_ip_on_launch = true
    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "us-west-2a-public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "us-west-2a-public" {
    subnet_id = "${aws_subnet.us-west-2a-public.id}"
    route_table_id = "${aws_route_table.us-west-2a-public.id}"
}


output "vpc_id" {
    value = "${aws_vpc.default.id}"
}

output "public_subnet" {
    value = "${aws_subnet.us-west-2a-public.id}"
}

output "rs_security_group" {
    value = "${aws_security_group.api-redshift-security-group.id}"
}

output "rs_client_security_group" {
    value = "${aws_security_group.api-redshift-dbmaint-security-group.id}"
}
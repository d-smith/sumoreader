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
    ingress {
        from_port = 5439
        to_port = 5439
        protocol = "tcp"
        cidr_blocks = ["52.70.63.192/27"]
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



/*
  Public Subnet
*/
resource "aws_subnet" "us-east-1a-public" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "us-east-1a-public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "us-east-1a-public" {
    subnet_id = "${aws_subnet.us-east-1a-public.id}"
    route_table_id = "${aws_route_table.us-east-1a-public.id}"
}


output "vpc_id" {
    value = "${aws_vpc.default.id}"
}


output "public_subnet" {
    value = "${aws_subnet.us-east-1a-public.id}"
}

output "rs_security_group" {
    value = "${aws_security_group.api-redshift-security-group.id}"
}


resource "aws_redshift_subnet_group" "api-subnet-group" {
    name = "api-subnet-group"
    description = "subnet group for api redshift cluster"
    subnet_ids = ["${var.redshift_subnet_id}"]
}

resource "aws_redshift_security_group" "api-redshift-security-group" {
    name = "api-redshift-sg"
    description = "security group for api redshift cluster"

    # Firehose Ingress
    ingress {
        cidr = "52.70.63.192/27"
    }

    # Ingress from public VPC
    ingress {
            cidr = "10.0.0.0/24"
    }
}


output "rs_subnet_group" {
    value = "${aws_redshift_subnet_group.api-subnet-group.id}"
}

output "rs_security_group" {
    value = "${aws_redshift_security_group.api-redshift-security-group.id}"
}


resource "aws_redshift_subnet_group" "api-subnet-group" {
    name = "api-subnet-group"
    description = "subnet group for api redshift cluster"
    subnet_ids = ["${var.redshift_subnet_id}"]
}



resource "aws_redshift_cluster" "api-cluster" {
  cluster_identifier = "api-cluster"
  database_name = "apidb"
  master_username = "apimaster"
  master_password = "${var.master_pw}"
  node_type = "dc1.large"
  cluster_type = "single-node"
  cluster_subnet_group_name = "${aws_redshift_subnet_group.api-subnet-group.id}"
  vpc_security_group_ids = ["${var.vpc_security_group_id}"]
}



output "rs_subnet_group" {
    value = "${aws_redshift_subnet_group.api-subnet-group.id}"
}


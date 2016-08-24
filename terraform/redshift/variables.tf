variable "redshift_subnet_id" {}
variable "master_pw" {}
variable "vpc_security_group_id" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}
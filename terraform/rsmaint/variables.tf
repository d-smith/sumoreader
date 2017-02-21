variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-west-2"
}

variable "subnet" {}
variable "security_group" {}
variable "key_pair" {}
variable "instance_profile_name" {}
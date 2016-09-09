#!/bin/bash

vpc_id=$(aws ec2 describe-vpcs --filter "Name=tag:Name,Values=redshift-aws-vpc"|jq '.Vpcs[0].VpcId')
vpc_id=$(sed -e 's/^"//' -e 's/"$//' <<< $vpc_id)
echo $vpc_id

subnet_id=$(aws ec2 describe-subnets --filter "Name=vpc-id,Values=$vpc_id" --filter "Name=tag:Name,Values=Public Subnet"| jq '.Subnets[0].SubnetId')
subnet_id=$(sed -e 's/^"//' -e 's/"$//' <<< $subnet_id)
echo $subnet_id

sg_id=$(aws ec2 describe-security-groups --filters Name=group-name,Values=api-redshift-dbmaint-sg|jq .SecurityGroups[0].GroupId)
sg_id=$(sed -e 's/^"//' -e 's/"$//' <<< $sg_id)
echo $sg_id

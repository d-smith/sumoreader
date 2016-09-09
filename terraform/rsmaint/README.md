This subdirectory contains a terraform script to launch an ec2 instance
in the redshift subnet with the security group that allows ssh access.

The script requires the security group id and subnet id, you can get these
by running the getparams script.

On occasion the instance id can't be harvested - when that happens you can
go to the amazon console to get the public ip address or use the aws cli.

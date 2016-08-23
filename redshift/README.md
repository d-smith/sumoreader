Create a bastion host - ubuntu 14.4

Install psql

<pre>
sudo apt-get install postgresql-client
</pre>

Connect to redshift

<pre>
psql -h redshift.aws.com -p 5439 -U apimaster apidb
</pre>

Tables:

<pre>
create table callrecord (
    txnid varchar(100) constraint firstkey primary key,
    error bool not null,
    host varchar(100) not null,
    category varchar(100),
    name varchar(100) not null,
    sub varchar(50),
    aud varchar(100),
    duration integer not null
)
</pre>

Column list for firehose: `txnid,error,host,category,name,sub,aud,duration`

Note on the setup, you need to enable Firehose Ingress to the Redshift
VPC and use a public address for cluster.

* 52.70.63.192/27 for US East (N. Virginia)
* 52.89.255.224/27 for US West (Oregon)
* 52.19.239.192/27 for EU (Ireland)

<pre>
create table svccall (
    txnid varchar(100) constraint svccall_pk primary key,
    error bool not null,
    name varchar(100) not null,
    endpoint varchar(100) not null,
    duration integer not null
)
</pre>
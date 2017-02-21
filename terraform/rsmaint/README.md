This subdirectory contains a terraform script to launch an ec2 instance
in the redshift subnet with the security group that allows ssh access.

The script requires the security group id and subnet id, you can get these
by running the getparams script. Note you may need to set the
AWS\_DEFAULT\_REGION environment variable if you want to go against a 
region that is different from your default.

You may also need to set http\_proxy and https\_proxy environment variables as well.

On occasion the instance id can't be harvested - when that happens you can
go to the amazon console to get the public ip address or use the aws cli.

Run getparams.sh to get the security group and subnet id needed to launch
the instance. You can use the aws command line to get the address
of the cluster:

<pre>
aws redshift describe-clusters --region us-east-1|jq .Clusters[0].Endpoint.Address
</pre>

Once you log into the instance (which will have psql preinstalled) you
can connect to redshift like:

<pre>
psql -h redshift.aws.com -p 5439 -U apimaster apidb
</pre>


Some queries:

<pre>
select name, count(*) from callrecord
group by name order by count desc;
</pre>

<pre>
select aud, count(*) from callrecord
group by aud order by count desc;
</pre>

<pre>
select category, count(*) from callrecord
group by category order by count desc;
</pre>



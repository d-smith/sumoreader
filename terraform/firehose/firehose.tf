resource "aws_cloudwatch_log_group" "crs" {
  name = "/aws/kinesisfirehose/call-record-stream"
}

resource "aws_cloudwatch_log_group" "scs" {
  name = "/aws/kinesisfirehose/svc-call-stream"
}



resource "aws_s3_bucket" "bucket" {
  bucket = "xtds-tf-bucket"
  acl = "private"
}


resource "aws_iam_role" "firehose_api_role" {
   name = "firehose_api_role"
   assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "firehose_api_policy" {
    name = "firehose_api_policy"
    role = "${aws_iam_role.firehose_api_role.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::xtds-tf-bucket",
        "arn:aws:s3:::xtds-tf-bucket/*"
      ]
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}
EOF
}

resource "aws_kinesis_firehose_delivery_stream" "call_record_stream" {

  name = "call-record-stream"
  destination = "redshift"

  s3_configuration {
    role_arn = "${aws_iam_role.firehose_api_role.arn}"
    prefix = "cr/"
    bucket_arn = "${aws_s3_bucket.bucket.arn}"
    buffer_size = 10
    buffer_interval = 60
  }
  redshift_configuration {
    role_arn = "${aws_iam_role.firehose_api_role.arn}"
    cluster_jdbcurl = "jdbc:redshift://${var.redshift_endpoint}/apidb"
    username = "apimaster"
    password = "${var.master_pw}"
    data_table_name = "callrecord"
  }
}

resource "aws_kinesis_firehose_delivery_stream" "svc_call_stream" {

  name = "svc-call-stream"
  destination = "redshift"

  s3_configuration {
    role_arn = "${aws_iam_role.firehose_api_role.arn}"
    prefix = "sc/"
    bucket_arn = "${aws_s3_bucket.bucket.arn}"
    buffer_size = 10
    buffer_interval = 60
  }
  redshift_configuration {
    role_arn = "${aws_iam_role.firehose_api_role.arn}"
    cluster_jdbcurl = "jdbc:redshift://${var.redshift_endpoint}/apidb"
    username = "apimaster"
    password = "${var.master_pw}"
    data_table_name = "svccall"
  }
}


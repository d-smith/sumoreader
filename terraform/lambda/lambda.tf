resource "aws_iam_role" "api_lambda_role" {
  name = "api_lambda_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "api_s3_exec_lambda_policy" {
  name = "api_s3_exec_lambda_policy"
  role = "${aws_iam_role.api_lambda_role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": "arn:aws:s3:::*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "api_basic_exec_lambda_policy" {
  name = "api_basic_exec_lambda_policy"
  role = "${aws_iam_role.api_lambda_role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
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

resource "aws_iam_role_policy" "api_parser_lambda_policy" {
  name = "api_parser_lambda_policy"
  role = "${aws_iam_role.api_lambda_role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1471984334000",
            "Effect": "Allow",
            "Action": [
                "firehose:PutRecord"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}


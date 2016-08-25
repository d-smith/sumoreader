#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <bucket name>"
    exit 1
fi

lambda_arn=$(aws lambda  list-functions \
    | jq -r ".Functions | .[] | select(.FunctionName==\"apiLogParserFn\") \
    | .FunctionArn")

read -r -d '' EVENT << EOF
{
    "LambdaFunctionConfigurations": [{
        "Id":"invoke_parse_fn",
        "LambdaFunctionArn": "$lambda_arn",
        "Events": [
            "s3:ObjectCreated:*"
        ]
    }]
}
EOF

aws lambda add-permission --function-name apiLogParserFn --statement-id AllowLambdaInvokeFunction \
    --action "lambda:InvokeFunction" --principal s3.amazonaws.com --source-arn "arn:aws:s3:::$1"

aws s3api put-bucket-notification-configuration \
        --bucket $1 \
        --notification-configuration "$EVENT"
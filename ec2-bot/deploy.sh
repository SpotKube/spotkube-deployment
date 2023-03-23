#!/bin/bash

function print_title() {
        echo -e "\033[1;34m$1\033[0m"
}

function print_error() {
	echo -e "\033[0;31mERROR: $1\033[0m"
}

region="us-east-1"

mkdir -p ./pkgs
template_1="./template.yaml"
template_2="./pkgs/template_$region.yaml"

stack_name="ec2-automation-stack"
s3_bucket="ec2-automation-deployments"

aws s3api create-bucket --bucket ${s3_bucket} --region ${region} --no-cli-pager > /dev/null

sam package --template-file $template_1 --region $region --s3-bucket $s3_bucket --output-template-file $template_2

sam deploy --region $region --template-file $template_2 --stack-name  $stack_name \
    --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND --no-fail-on-empty-changeset

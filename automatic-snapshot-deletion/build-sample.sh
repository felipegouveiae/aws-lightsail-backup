#!/bin/sh

aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 433054139090.dkr.ecr.us-east-2.amazonaws.com

docker build \
    --platform=linux/x86_64 \
    -t aws-lightsail-instance-snapshot-deleter .

docker tag aws-lightsail-instance-snapshot-deleter:latest \
    433054139090.dkr.ecr.us-east-2.amazonaws.com/aws-lightsail-instance-snapshot-deleter:latest

docker push 433054139090.dkr.ecr.us-east-2.amazonaws.com/aws-lightsail-instance-snapshot-deleter:latest
#!/bin/sh

IMAGE=$1
ECR_URI=$2
ERC_REGION=$3

docker build --tag $IMAGE .
docker tag $IMAGE:latest $ECR_URI
docker push $ECR_URI

aws ecr get-login-password --region $ERC_REGION | docker login --username AWS --password-stdin $2
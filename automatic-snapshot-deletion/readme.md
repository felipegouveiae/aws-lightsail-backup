# This repo contains the scripts to :  # 

1. Build a ECR Docker Image to backup lightsail instances
2. Create a container do stop your lightsail instance, generate e snapshot and get your instance running again.

All the settings are set to the container using hte following environment variables:

AWS_KEY, AWS_SECRET: Key and secret with the permission to start instance, stop instance,read instances, create snapshots, read snapshots

AWS_REGION: Instance Region
INSTANCE_NAME: Instance Name

# build image 

$ build-docker.sh YOUR_IMAGE_NAME YOUR_ECR_IMAGE_URI YOUR_ECR_IMAGE_REGION

# backup.sh

Checks if all the necessary variables are set;
Sends a "stop instance" command;
Wait until the instance is stopped. This is important for windows because AWS does not create snapshot of running instances for Windows;
Sends a command to create a instance snapshot;
Waits until the snapshot finishes (status "available");
Sends a command to start the instance;

# Deployment on AWS

The easiest and less expensive way to run this backup container is to get it into a scheduled task into a Fargate Cluster.

1. Create task definition to run this image;
2. Create a AWS Fargate Cluster;
3. Created a Scheduled Task. Important: Assign a IP to the container otherwise it will not be able to download the image from ECR;

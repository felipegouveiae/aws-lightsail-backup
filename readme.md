# Which problem this project solves?

AWS Lightsail is amazing but it does not take instance snapshots for Windows instances. I have created this project to solve this problem.

# This repo contains two projects: 

1. backup: it contains a docker image source code that is meant to backup windows instances on AWS Lightsail. The docker image contains a script that will 1. stop the instance; 2. take a snapshot; 3. get the instance running again.

2. automatic-snapshot-deletion: this folder contains a nodejs docker image source code that will delete all the instance snapshots on AWS Lightsail after 90 days. Since the backup will only store the snapshots, this one will delete them after 90 days to avoid unnecessary charges.

# How can you get that live on AWS?

I built those images into and stored them into my ECR (Elastic Container Registry) and created an Amazon ECS Task for each one of them. Then I created a cluster and added those tasks as "Scheduled Tasks" to run about 3am every day. Those tasks will day once the processing is completed.
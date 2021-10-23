#!/bin/sh

DATE_RETAIN_EXPRESSION=90d

max_date_string=$(date  -v-$DATE_RETAIN_EXPRESSION    +"%Y-%m-%d")
max_date_timestamp=$(date  -v-$DATE_RETAIN_EXPRESSION    +"%s")
 
 echo "deleting snapshots older than $max_date_string - max timestamp: $max_date_timestamp"
 
 aws lightsail get-instance-snapshots --region us-east-1 --max-items 20
#!/bin/sh

if test -z "$AWS_KEY" 
then
      echo "\$AWS_KEY CANNOT BE NULL";
      exit;
fi

if test -z "$AWS_SECRET"
then
      echo "\$AWS_SECRET CANNOT BE NULL";
      exit;
fi

if test -z "$AWS_REGION"
then
      echo "\$AWS_REGION CANNOT BE NULL";
      exit;
fi

if test -z "$INSTANCE_NAME"
then
      echo "\$INSTANCE_NAME CANNOT BE NULL";
      exit;
fi

TIME=$(date +%s)
PROFILE_NAME=aws-lightsail-backup-$INSTANCE_NAME

SNAPSHOT_AVAILABLE_REGEX="\"state\": \"available\""
INSTANCE_STOPPED_REGEX="\"name\": \"stopped\""

aws configure set \
    aws_access_key_id $AWS_KEY \
    --profile $PROFILE_NAME

aws configure set \
    aws_secret_access_key $AWS_SECRET \
    --profile $PROFILE_NAME

aws configure set \
    region $AWS_REGION \
    --profile $PROFILE_NAME

echo "Initializing backup $TIME of $INSTANCE_NAME - region $AWS_REGION ..."

aws lightsail stop-instance \
    --instance-name $INSTANCE_NAME  \
    --profile $PROFILE_NAME >> ./$TIME-01-stop-instance.log

echo "waiting instance to stop..."

while true
do
    instance_status=$(aws lightsail get-instance-state \
    --instance-name $INSTANCE_NAME \
    --profile $PROFILE_NAME)

    if [[ $instance_status =~ $INSTANCE_STOPPED_REGEX ]]; then 
        echo "instance $INSTANCE_NAME is stopped";
        break; 
    fi

    sleep 30s
done

aws lightsail create-instance-snapshot \
    --instance-name $INSTANCE_NAME  \
    --instance-snapshot-name $INSTANCE_NAME-$TIME \
    --profile $PROFILE_NAME >> ./$TIME-02-snapshot-create.log    

while true
do
    snapshot_status=$(aws lightsail get-instance-snapshot \
        --instance-snapshot-name $INSTANCE_NAME-$TIME \
        --profile $PROFILE_NAME)

    echo "current status: $snapshot_status"

    if [[ $snapshot_status =~ $SNAPSHOT_AVAILABLE_REGEX ]]; then 
        echo "snapshot $INSTANCE_NAME-$TIME completed";
        break; 
    fi

    sleep 30s
done

aws lightsail start-instance \
    --instance-name $INSTANCE_NAME  \
    --profile $PROFILE_NAME >> ./$TIME-03-start-instance.log

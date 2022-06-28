#!/bin/sh
instances=$(aws ec2 describe-instances --region "$AWS_REGION" --query 'Reservations[].Instances[].InstanceId' --filters "Name=tag:Name,Values=$INSTANCE_TAG_NAME" --output text)

if [ -n "$instances" ]; then
    aws ec2 terminate-instances --region "$AWS_REGION" --instance-ids "$instances"
fi

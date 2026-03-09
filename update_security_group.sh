#!/bin/bash 

# Set environment variables for AWS credentials (set at runtime)
export $AWS_ACCESS_KEY_ID
export $AWS_SECRET_ACCESS_KEY
export AWS_REGION=us-east-2

INSTANCE_ID="i-0913b241718008d3d"

# SECURITY_GROUP_ID=$(aws ec2 describe-instances --instance-id $INSTANCE_ID --query 'Reservations[0].Instances[0].SecurityGroups[0].GroupId' --output text) 

# echo $SECURITY_GROUP_ID

# aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol tcp --port 3389 --cidr 63.89.11.199/32


docker run -e AWS_ACCESS_KEY_ID=$1 -e AWS_SECRET_ACCESS_KEY=$2 \
  aws-runner "aws ec2 describe-instances"
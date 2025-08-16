#!/bin/bash 

INSTANCE_ID="i-0913b241718008d3d"

SECURITY_GROUP_ID=$(aws ec2 describe-instances --instance-id $INSTANCE_ID --query 'Reservations[0].Instances[0].SecurityGroups[0].GroupId' --output text) 

aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol tcp --port 3389 --cidr 129.222.2.9/32

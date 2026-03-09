#!/bin/bash
docker run -e AWS_ACCESS_KEY_ID=$1 -e AWS_SECRET_ACCESS_KEY=$2 \
  aws-runner "aws lambda invoke --function-name InstanceStarter --payload '{}' /dev/stdout"
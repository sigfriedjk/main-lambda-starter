#!/bin/bash
docker run -e AWS_ACCESS_KEY_ID=$1 -e AWS_SECRET_ACCESS_KEY=$2 \
  --entrypoint "/bin/bash" aws-runner  -c "aws lambda invoke --function-name InstanceStarter --payload '{}' /dev/stdout"
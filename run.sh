#!/bin/bash
docker run --rm \
  -e AWS_ACCESS_KEY_ID=$1 \
  -e AWS_SECRET_ACCESS_KEY=$2 \
  aws-lambda-runner

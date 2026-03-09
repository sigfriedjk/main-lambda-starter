#!/bin/bash

# Check for args
if [ -z "$2" ]; then
  echo "Usage: ./reset-s3.sh <ACCESS_KEY> <SECRET_KEY>"
  exit 1
fi

BUCKET_NAME="jk-main-stash"
AKID=$1
SAK=$2

# The query filters for IA or Intelligent Tiering
QUERY="Contents[?StorageClass=='INTELLIGENT_TIERING' || StorageClass=='STANDARD_IA'].Key"

docker run --rm \
  -e AWS_ACCESS_KEY_ID="$AKID" \
  -e AWS_SECRET_ACCESS_KEY="$SAK" \
  -e AWS_DEFAULT_REGION="us-east-1" \
  --entrypoint "/bin/bash" \
  aws-runner -c "aws s3api list-objects-v2 --bucket $BUCKET_NAME --query \"$QUERY\" --output json | jq -j '.[] | . + \"\\u0000\"' | xargs -0 -I {} aws s3 cp 's3://$BUCKET_NAME/{}' 's3://$BUCKET_NAME/{}' --storage-class STANDARD"
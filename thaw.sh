#!/bin/bash
AKID=$1
SAK=$2
BUCKET_NAME="jk-main-stash"

# Filters for any Glacier-type storage
QUERY="Contents[?StorageClass=='GLACIER' || StorageClass=='DEEP_ARCHIVE'].Key"

docker run --rm \
  -e AWS_ACCESS_KEY_ID="$AKID" \
  -e AWS_SECRET_ACCESS_KEY="$SAK" \
  -e AWS_DEFAULT_REGION="us-east-1" \
  --entrypoint "/bin/bash" \
  aws-runner -c "aws s3api list-objects-v2 --bucket $BUCKET_NAME --query \"$QUERY\" --output json | jq -j '.[] | . + \"\\u0000\"' | xargs -0 -I {} aws s3api restore-object --bucket $BUCKET_NAME --key \"{}\" --restore-request '{\"Days\":7,\"GlacierJobParameters\":{\"Tier\":\"Standard\"}}'"
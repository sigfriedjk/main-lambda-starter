#!/bin/bash
AKID=$1
SAK=$2
BUCKET_NAME="jk-main-stash"
DB_FILE="restored_keys.log"
MANIFEST="s3_keys_to_restore.json"

# 1. Ensure the tracking database exists
touch "$DB_FILE"

# 2. Fetch the list of files if the manifest doesn't exist
if [ ! -f "$MANIFEST" ]; then
    echo "Fetching object list from S3..."
    docker run --rm \
      -e AWS_ACCESS_KEY_ID="$AKID" \
      -e AWS_SECRET_ACCESS_KEY="$SAK" \
      -e AWS_DEFAULT_REGION="us-east-1" \
      aws-runner s3api list-objects-v2 --bucket "$BUCKET_NAME" \
      --query "Contents[?StorageClass=='GLACIER' || StorageClass=='DEEP_ARCHIVE'].Key" \
      --output json > "$MANIFEST"
fi

# 3. Process the files
echo "Starting restore process..."
jq -r '.[]' "$MANIFEST" | while read -r KEY; do
    # Skip if key is already in our local database
    if grep -qF "$KEY" "$DB_FILE"; then
        echo "Skipping: $KEY (Already processed or in progress)"
        continue
    fi

    echo "Requesting restore for: $KEY"
    
    # Run the restore command
    RESPONSE=$(docker run --rm \
      -e AWS_ACCESS_KEY_ID="$AKID" \
      -e AWS_SECRET_ACCESS_KEY="$SAK" \
      -e AWS_DEFAULT_REGION="us-east-1" \
      aws-runner s3api restore-object \
      --bucket "$BUCKET_NAME" \
      --key "$KEY" \
      --restore-request '{"Days":7,"GlacierJobParameters":{"Tier":"Standard"}}' 2>&1)

    EXIT_CODE=$?

    if [ $EXIT_CODE -eq 0 ]; then
        echo "$KEY" >> "$DB_FILE"
        echo "Success: Restore initiated."
    elif [[ "$RESPONSE" == *"RestoreAlreadyInProgress"* ]]; then
        echo "$KEY" >> "$DB_FILE"
        echo "Note: Restore already in progress for $KEY. Added to DB."
    else
        echo "Error restoring $KEY: $RESPONSE"
    fi
done
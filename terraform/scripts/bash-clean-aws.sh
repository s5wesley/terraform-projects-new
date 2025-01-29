#!/bin/bash

AWS_REGION="us-east-1"
AWS_PROFILE="default"

# Function to check dependencies
check_dependencies() {
  for cmd in aws jq; do
    if ! command -v $cmd &>/dev/null; then
      echo "Error: $cmd is not installed. Please install it and rerun the script."
      exit 1
    fi
  done
}

# Function to fetch all AMIs with names starting with 'backup'
fetch_amis() {
  aws ec2 describe-images \
    --owners self \
    --filters "Name=name,Values=backup-*" \
    --query "Images[*].[ImageId,Name,CreationDate,BlockDeviceMappings]" \
    --output json \
    --region $AWS_REGION \
    --profile $AWS_PROFILE
}

# Function to delete old AMIs and their associated snapshots
delete_old_amis() {
  echo "Fetching AMIs with name starting with 'backup'..."

  # Fetch AMIs
  AMIS=$(fetch_amis | tr -d '\r')

  if [ -z "$AMIS" ] || [ "$AMIS" == "[]" ]; then
    echo "No AMIs found with name starting with 'backup'."
    return
  fi

  # Sort AMIs by creation date in descending order
  SORTED_AMIS=$(echo "$AMIS" | jq -r 'sort_by(.[2]) | reverse')

  # Check if there are more than 4 AMIs
  AMIS_COUNT=$(echo "$SORTED_AMIS" | jq '. | length')
  if [ "$AMIS_COUNT" -le 4 ]; then
    echo "Only $AMIS_COUNT AMIs found, no old AMIs to delete."
    return
  fi

  # Keep the latest 4 AMIs, delete older ones
  AMIS_TO_DELETE=$(echo "$SORTED_AMIS" | jq -r '.[4:]')

  echo "$AMIS_TO_DELETE" | jq -c '.[]' | while read -r ami; do
    AMI_ID=$(echo "$ami" | jq -r '.[0]')
    AMI_NAME=$(echo "$ami" | jq -r '.[1]')
    
    echo "Deregistering AMI: $AMI_NAME ($AMI_ID)"
    aws ec2 deregister-image --image-id "$AMI_ID" --region $AWS_REGION --profile $AWS_PROFILE

    # Extract associated snapshot IDs and delete them
    SNAPSHOT_IDS=$(echo "$ami" | jq -r '.[3][]?.Ebs.SnapshotId' | grep -v null)

    if [ -n "$SNAPSHOT_IDS" ]; then
      for SNAPSHOT_ID in $SNAPSHOT_IDS; do
        echo "Deleting snapshot: $SNAPSHOT_ID"
        aws ec2 delete-snapshot --snapshot-id "$SNAPSHOT_ID" --region $AWS_REGION --profile $AWS_PROFILE
      done
    else
      echo "No associated snapshots found for AMI: $AMI_NAME ($AMI_ID)"
    fi
  done
}

# Main script execution
check_dependencies
delete_old_amis

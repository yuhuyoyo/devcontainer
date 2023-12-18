#!/bin/bash

function get_ec2_tag() {
  if [ -z "$1" ]; then
    echo "usage: get_metadata_attributes.sh <tag>"
    exit 1
  fi
  local tag_key="$1"

  local tag_value
  INSTANCE_ID=$(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id)
  tag_value=$(aws ec2 describe-tags \
    --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=$tag_key" \
    --query "Tags[0].Value" --output text 2>/dev/null)

  echo "$tag_value"
}

#!/bin/bash
# Usage: ./script.sh <pattern>
# Example: ./script.sh sandbox

PATTERN="$1"

if [ -z "$PATTERN" ]; then
  echo "Usage: $0 <pattern>"
  exit 1
fi

aws organizations list-accounts --query 'Accounts[*].[Name, Id]' --output json \
  | jq -r --arg pat "$PATTERN" 'map(select(.[0] | test($pat; "i"))) | .[] | .[1]'                            

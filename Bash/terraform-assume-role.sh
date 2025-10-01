#!/bin/bash

# echo "Helper script to automatically retrieve and assume appropriate role"

# hold the arguments
ROLE_ARN=$(aws iam list-roles --query 'Roles[?contains(RoleName, `Organizations`)]' | jq -r '.[].Arn')
ROLE_SESSION_NAME=$1

# echo $ROLE_ARN

# check if arguments are passed
if [ -z "$1" ]; then
    echo "Error: missing ROLE_SESSION_NAME, try again with $0 <ROLE_SESSION_NAME>"
    exit 1
fi

echo "Will try to assume a role $ROLE_ARN with session name $1..."
echo "==========================================================="

aws sts assume-role \
    --role-arn $ROLE_ARN \
    --role-session-name $1

#!/bin/bash

# echo "Helper script to automatically retrieve and assume appropriate role"
BASE_DIR="/tmp"
EXTENSION="json"

aws organizations list-accounts --query 'Accounts[*].[Name, Arn]' | jq -r '.[]' > "${BASE_DIR}/ouput"
# hold the arguments

sed 's/\] \[/\],\[/g; 1s/^/[ /; $s/$/ ]/' "${BASE_DIR}/ouput" > "${BASE_DIR}/ouput.${EXTENSION}"

jq -c "${BASE_DIR}/ouput.${EXTENSION}" | while read -r line; do
    # Extract alias and ARN
    alias=$(echo "$line" | jq -r '.[0]')
    arn=$(echo "$line" | jq -r '.[1]')

    # Extract the numeric account ID from ARN
    account_id=$(echo "$arn" | awk -F'/' '{print $NF}')

    echo "Alias: $alias"
    echo "ARN: $arn"
    echo "Account ID: $account_id"
    echo "---------------------------------"
done

#!/bin/bash
# Usage: ./script.sh <pattern> <usersession name>
# Example: ./script.sh sandbox temp-session

# global options
PATTERN="${1:-}"
SESSION_PREFIX="${2:-terraform}"
LOG_DIR="log-execution"
TIME_STAMP=$(date +"%H_%M_%d_%m_%Y")
ROLE_PATTERN="arn:aws:iam::account_id:role/OrganizationAccountAccessRole"

set -euo pipefail

assume_role () {
  echo "[INFO] Searching for AWS account matching pattern: $PATTERN" >> "${LOG_DIR}-${TIME_STAMP}.log"
  # search through the organization list to check the account with matched pattern
  local account_id=$(aws organizations list-accounts --query 'Accounts[*].[Name, Id]' --output json \
  | jq -r --arg pat "$PATTERN" 'map(select(.[0] | test($pat; "i"))) | .[] | .[1]')
  
  local role_name=$(echo "${SESSION_ROLE}-$TIME_STAMP")
  
  local role_to_assume=$(echo "${ROLE_PATTERN}" | sed "s/account\_id/${account_id}/g")

  # echo $role_to_assume
  # echo $role_name

  # echo $(aws sts assume-role \
  #   --role-arn "${role_to_assume}" \
  #   --role-session-name "${role_name}")
  if [[ -z "$account_id" || "$account_id" == "null" ]]; then
    echo "[ERROR] No account found matching pattern '$PATTERN'" >> "${LOG_DIR}-${TIME_STAMP}.error"
    exit 1
  fi

  CREDS_JSON=$(aws sts assume-role \
    --role-arn "${role_to_assume}" \
    --role-session-name "${role_name}")

  export AWS_ACCESS_KEY_ID=$(echo "$CREDS_JSON" | jq -r '.Credentials.AccessKeyId')
  export AWS_SECRET_ACCESS_KEY=$(echo "$CREDS_JSON" | jq -r '.Credentials.SecretAccessKey')
  export AWS_SESSION_TOKEN=$(echo "$CREDS_JSON" | jq -r '.Credentials.SessionToken')
}


if [ -z "$PATTERN" ]; then
  echo "Usage: $0 <pattern>"
  exit 1
fi

# echo $ACCOUNT_ID
# echo $ASSUMED_ROLE
assume_role

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

# Function to list unused EC2 security groups
list_unused_security_groups() {
  echo -e "\nFetching all security groups..."
  security_groups=$(aws ec2 describe-security-groups \
    --query "SecurityGroups[*].{GroupId:GroupId,GroupName:GroupName}" \
    --output json --region $AWS_REGION --profile $AWS_PROFILE)

  echo -e "Fetching all network interfaces..."
  used_sg_ids=$(aws ec2 describe-network-interfaces \
    --query "NetworkInterfaces[*].Groups[*].GroupId" \
    --output json --region $AWS_REGION --profile $AWS_PROFILE | jq -r 'if . == [] then [] else .[][] end' | sort -u)

  unused_sgs=$(echo "$security_groups" | jq -c --argjson used "[$used_sg_ids]" \
    '[.[] | select(.GroupId as $id | ($used | index($id) | not) and .GroupName != "default")]')

  echo -e "\nUnused Security Groups:"
  echo "$unused_sgs" | jq -r '.[] | "- \(.GroupId) (\(.GroupName))"'

  # Ensure valid JSON is returned
  if [ -z "$unused_sgs" ] || [ "$unused_sgs" == "null" ]; then
    echo "[]"  # Return empty JSON array
  else
    echo "$unused_sgs"
  fi
}

# Function to list unused IAM policies
list_unused_iam_policies() {
  echo -e "\nFetching all IAM policies..."
  unused_policies=$(aws iam list-policies --scope Local \
    --query "Policies[?AttachmentCount==\`0\`].[PolicyName,Arn]" \
    --output json --profile $AWS_PROFILE)

  echo -e "\nUnused IAM Policies:"
  echo "$unused_policies" | jq -r '.[] | "- \(.[])"'

  # Ensure valid JSON is returned
  if [ -z "$unused_policies" ] || [ "$unused_policies" == "null" ]; then
    echo "[]"  # Return empty JSON array
  else
    echo "$unused_policies"
  fi
}

# Function to list unused IAM roles
list_unused_iam_roles() {
  echo -e "\nFetching all IAM roles..."
  roles=$(aws iam list-roles --query "Roles[*].RoleName" --output json --profile $AWS_PROFILE)

  unused_roles=()
  for role in $(echo "$roles" | jq -r '.[]'); do
    last_used=$(aws iam get-role --role-name "$role" \
      --query "Role.RoleLastUsed.LastUsedDate" --output text --profile $AWS_PROFILE 2>/dev/null)
    if [ "$last_used" == "None" ]; then
      unused_roles+=("$role")
    fi
  done

  echo -e "\nUnused IAM Roles:"
  for role in "${unused_roles[@]}"; do
    echo "- $role"
  done

  # Ensure valid JSON is returned
  if [ ${#unused_roles[@]} -eq 0 ]; then
    echo "[]"  # Return empty JSON array
  else
    printf '%s\n' "${unused_roles[@]}" | jq -R . | jq -s .
  fi
}

# Function to save results to JSON
save_results_to_json() {
  echo -e "\nSaving results to unused_aws_resources.json..."

  # Store results before writing JSON
  deleted_sgs=$(list_unused_security_groups)
  deleted_policies=$(list_unused_iam_policies)
  deleted_roles=$(list_unused_iam_roles)

  # Write JSON file
  cat <<EOF > unused_aws_resources.json
{
  "unused_security_groups": $deleted_sgs,
  "unused_iam_policies": $deleted_policies,
  "unused_iam_roles": $deleted_roles
}
EOF
  echo "Results saved to unused_aws_resources.json."
}

# Main function
main() {
  check_dependencies
  echo -e "\nListing unused AWS resources..."
  
  unused_sgs=$(list_unused_security_groups)
  unused_policies=$(list_unused_iam_policies)
  unused_roles=$(list_unused_iam_roles)

  echo -e "\nSummary:"
  echo "- Unused Security Groups: $(echo "$unused_sgs" | jq length)"
  echo "- Unused IAM Policies: $(echo "$unused_policies" | jq length)"
  echo "- Unused IAM Roles: $(echo "$unused_roles" | jq length)"

  save_results_to_json
}

# Execute the script
main

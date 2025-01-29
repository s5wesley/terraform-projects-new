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

# Function to delete unused EC2 security groups
delete_unused_security_groups() {
  echo -e "\nFetching all security groups..."
  security_groups=$(aws ec2 describe-security-groups \
    --query "SecurityGroups[*].{GroupId:GroupId,GroupName:GroupName}" \
    --output json --region $AWS_REGION --profile $AWS_PROFILE)

  echo -e "Fetching all network interfaces..."
  used_sg_ids=$(aws ec2 describe-network-interfaces \
    --query "NetworkInterfaces[*].Groups[*].GroupId" \
    --output json --region $AWS_REGION --profile $AWS_PROFILE | jq -r '.[][]' | sort -u || echo "[]")

  unused_sgs=$(echo "$security_groups" | jq -c --argjson used "[$used_sg_ids]" \
    '[.[] | select(.GroupId as $id | ($used | index($id) | not) and .GroupName != "default")]')

  echo -e "\nDeleting Unused Security Groups:"
  echo "$unused_sgs" | jq -r '.[] | "- \(.GroupId) (\(.GroupName))"'

  for sg_id in $(echo "$unused_sgs" | jq -r '.[].GroupId'); do
    echo "Deleting Security Group: $sg_id"
    aws ec2 delete-security-group --group-id "$sg_id" --region $AWS_REGION --profile $AWS_PROFILE
  done
}

# Function to delete unused IAM policies
delete_unused_iam_policies() {
  echo -e "\nFetching all IAM policies..."
  unused_policies=$(aws iam list-policies --scope Local \
    --query "Policies[?AttachmentCount==\`0\`].[PolicyName,Arn]" \
    --output json --profile $AWS_PROFILE)

  echo -e "\nDeleting Unused IAM Policies:"
  echo "$unused_policies" | jq -r '.[] | "- \(.[])"'

  for policy_arn in $(echo "$unused_policies" | jq -r '.[].1'); do
    echo "Deleting IAM Policy: $policy_arn"
    aws iam delete-policy --policy-arn "$policy_arn" --profile $AWS_PROFILE
  done
}

# Function to delete unused IAM roles
delete_unused_iam_roles() {
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

  echo -e "\nDeleting Unused IAM Roles:"
  for role in "${unused_roles[@]}"; do
    echo "Deleting IAM Role: $role"
    aws iam delete-role --role-name "$role" --profile $AWS_PROFILE
  done
}

# Function to save results to JSON
save_results_to_json() {
  echo -e "\nSaving results to unused_aws_resources.json..."

  deleted_sgs=$(delete_unused_security_groups)
  deleted_policies=$(delete_unused_iam_policies)
  deleted_roles=$(delete_unused_iam_roles)

  cat <<EOF > unused_aws_resources.json
{
  "deleted_security_groups": $deleted_sgs,
  "deleted_iam_policies": $deleted_policies,
  "deleted_iam_roles": $deleted_roles
}
EOF
  echo "Results saved to unused_aws_resources.json."
}

# Main function
main() {
  check_dependencies
  echo -e "\nDeleting unused AWS resources..."

  delete_unused_security_groups
  delete_unused_iam_policies
  delete_unused_iam_roles

  echo -e "\nCleanup Summary:"
  echo "- Deleted Security Groups"
  echo "- Deleted IAM Policies"
  echo "- Deleted IAM Roles"

  save_results_to_json
}

# Execute the script
main

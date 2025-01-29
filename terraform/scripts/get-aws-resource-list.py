import boto3
import json
from botocore.exceptions import NoCredentialsError, PartialCredentialsError

# AWS session initialization
try:
    session = boto3.Session()
    ec2_client = session.client('ec2')
    iam_client = session.client('iam')
except (NoCredentialsError, PartialCredentialsError):
    print("Error: AWS credentials not found. Please configure AWS credentials.")
    exit(1)

def list_unused_security_groups():
    """List all unused EC2 security groups."""
    print("\nFetching all security groups...")
    security_groups = ec2_client.describe_security_groups()['SecurityGroups']

    print("Fetching all network interfaces...")
    network_interfaces = ec2_client.describe_network_interfaces()['NetworkInterfaces']

    # Get security groups that are in use
    used_sg_ids = set(
        sg['GroupId']
        for ni in network_interfaces
        for sg in ni['Groups']
    )

    # Find unused security groups (excluding the default group)
    unused_sgs = [
        sg for sg in security_groups
        if sg['GroupId'] not in used_sg_ids and sg['GroupName'] != 'default'
    ]

    print("\nUnused Security Groups:")
    for sg in unused_sgs:
        print(f"- {sg['GroupId']} ({sg['GroupName']})")

    return unused_sgs

def list_unused_iam_policies():
    """List all unused IAM policies."""
    print("\nFetching all IAM policies...")
    
    # Get all IAM policies with no attachments
    policies = iam_client.list_policies(Scope='Local')['Policies']
    unused_policies = [policy for policy in policies if policy.get('AttachmentCount', 0) == 0]

    print("\nUnused IAM Policies:")
    for policy in unused_policies:
        print(f"- {policy['PolicyName']} ({policy['Arn']})")

    return unused_policies

def list_unused_iam_roles():
    """List all IAM roles that have never been used."""
    print("\nFetching all IAM roles...")
    roles = iam_client.list_roles()['Roles']

    unused_roles = []
    for role in roles:
        role_name = role['RoleName']
        last_used = role.get('RoleLastUsed', {}).get('LastUsedDate')

        if not last_used:  # Role has never been used
            unused_roles.append(role_name)

    print("\nUnused IAM Roles:")
    for role_name in unused_roles:
        print(f"- {role_name}")

    return unused_roles

def save_results_to_json():
    """Save the results to a JSON file."""
    print("\nSaving results to unused_aws_resources.json...")

    # Fetch unused resources
    unused_sgs = list_unused_security_groups()
    unused_policies = list_unused_iam_policies()
    unused_roles = list_unused_iam_roles()

    results = {
        "unused_security_groups": [sg['GroupId'] for sg in unused_sgs],
        "unused_iam_policies": [policy['Arn'] for policy in unused_policies],
        "unused_iam_roles": unused_roles
    }

    with open("unused_aws_resources.json", "w") as file:
        json.dump(results, file, indent=4)

    print("Results saved to unused_aws_resources.json.")

def main():
    """Main function."""
    print("\nListing unused AWS resources...\n")
    
    save_results_to_json()

if __name__ == "__main__":
    main()

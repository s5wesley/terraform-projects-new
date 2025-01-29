import boto3
import json
from botocore.exceptions import NoCredentialsError, PartialCredentialsError, ClientError

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

def delete_unused_security_groups():
    """Delete unused EC2 security groups."""
    unused_sgs = list_unused_security_groups()

    if not unused_sgs:
        print("\nNo unused security groups found. Nothing to delete.")
        return

    print("\nDeleting unused security groups...")

    for sg in unused_sgs:
        sg_id = sg['GroupId']
        sg_name = sg['GroupName']

        try:
            ec2_client.delete_security_group(GroupId=sg_id)
            print(f"Successfully deleted security group: {sg_name} ({sg_id})")
        except ClientError as e:
            print(f"Failed to delete security group {sg_name} ({sg_id}): {e}")

def main():
    """Main function."""
    print("\nDeleting only unused security groups...\n")
    
    delete_unused_security_groups()

if __name__ == "__main__":
    main()

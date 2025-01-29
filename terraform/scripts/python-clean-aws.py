import boto3
from datetime import datetime

# AWS configuration
AWS_REGION = "us-east-1"
AWS_PROFILE = "default"

def delete_old_amis():
    """Delete old AMIs that start with 'backup-', keeping only the latest 4 and deleting associated snapshots."""
    try:
        # Start a session with AWS using the specified profile
        session = boto3.Session(profile_name=AWS_PROFILE)
        ec2_client = session.client('ec2', region_name=AWS_REGION)

        print("Fetching AMIs with name starting with 'backup-'...")

        # Fetch all AMIs with names starting with 'backup-'
        response = ec2_client.describe_images(
            Owners=['self'],
            Filters=[{'Name': 'name', 'Values': ['backup-*']}]
        )

        amis = response['Images']

        if not amis:
            print("No AMIs found with name starting with 'backup-'.")
            return

        # Sort AMIs by creation date in descending order
        amis.sort(key=lambda x: x['CreationDate'], reverse=True)

        # Ensure there are at least 5 AMIs before deleting
        if len(amis) <= 4:
            print(f"Only {len(amis)} AMIs found, no old AMIs to delete.")
            return

        # Keep the latest 4 AMIs and delete the rest
        amis_to_delete = amis[4:]

        for ami in amis_to_delete:
            ami_id = ami['ImageId

import boto3

def delete_all_snapshots():
    ec2 = boto3.client('ec2')
    
    # Retrieve all snapshots in the account
    all_snapshots = ec2.describe_snapshots(OwnerIds=['self'])['Snapshots']
    
    if not all_snapshots:
        print("No snapshots found in the account.")
    else:
        print(f"Deleting snapshots in the account...")
        for snapshot in all_snapshots:
            snapshot_id = snapshot['SnapshotId']
            
            # Check if the snapshot is in use by an AMI
            used_by_amis = ec2.describe_images(Filters=[{'Name': 'block-device-mapping.snapshot-id', 'Values': [snapshot_id]}])['Images']
            
            if used_by_amis:
                print(f"Skipping deletion of snapshot {snapshot_id} used by AMI(s)")
            else:
                ec2.delete_snapshot(SnapshotId=snapshot_id)
                print(f"Deleted snapshot: {snapshot_id}")

def main():
    print("\nDeleting all snapshots in the AWS account...\n")
    delete_all_snapshots()

if __name__ == "__main__":
    main()
import boto3
import json
from datetime import datetime, timedelta, timezone
from botocore.exceptions import NoCredentialsError, PartialCredentialsError

# Initialize AWS clients
try:
    session = boto3.Session()
    rds_client = session.client("rds")
    ec2_client = session.client("ec2")
    cloudwatch_client = session.client("cloudwatch")
except (NoCredentialsError, PartialCredentialsError):
    print("Error: AWS credentials not found. Please configure AWS credentials.")
    exit(1)

# Best Practice Checks
CHECKS = [
    "Encryption", "Public Accessibility", "Automated Backups", "Multi-AZ Deployment",
    "Instance Type", "Idle Instance", "Security Group Rules", "Storage Type",
    "Database Engine Version", "Enhanced Monitoring", "Performance Insights",
    "Backup Retention Period", "Maintenance Window", "IAM Authentication",
    "Public Snapshot Sharing", "Deletion Protection"
]

def log_info(message):
    print(f"[INFO] {message}")

def log_warning(message):
    print(f"[WARNING] {message}")

def separator():
    print("-" * 80)

# Check Functions
def check_rds_encryption(db_instance):
    return "Encrypted" if db_instance.get("StorageEncrypted") else "Not Encrypted"

def check_public_accessibility(db_instance):
    return "Publicly Accessible" if db_instance.get("PubliclyAccessible") else "Not Publicly Accessible"

def check_automated_backups(db_instance):
    return "Backups Enabled" if db_instance.get("BackupRetentionPeriod", 0) > 0 else "Backups Disabled"

def check_multi_az(db_instance):
    return "Multi-AZ Enabled" if db_instance.get("MultiAZ") else "Single-AZ"

def check_instance_type(db_instance):
    instance_class = db_instance["DBInstanceClass"]
    return f"Instance Type: {instance_class}"

def check_idle_instance(db_instance):
    db_identifier = db_instance["DBInstanceIdentifier"]
    end_time = datetime.now(timezone.utc)
    start_time = end_time - timedelta(days=7)  # Look at the last 7 days

    metrics = cloudwatch_client.get_metric_data(
        MetricDataQueries=[{
            "Id": "cpu",
            "MetricStat": {
                "Metric": {
                    "Namespace": "AWS/RDS",
                    "MetricName": "CPUUtilization",
                    "Dimensions": [{"Name": "DBInstanceIdentifier", "Value": db_identifier}],
                },
                "Period": 86400,
                "Stat": "Average",
            },
            "ReturnData": True,
        }],
        StartTime=start_time,
        EndTime=end_time,
    )

    cpu_utilization = metrics["MetricDataResults"][0]["Values"]
    if cpu_utilization and max(cpu_utilization) < 10:
        return "Idle (Low Utilization)"
    return "Active (Utilized)"

def check_public_snapshot_sharing():
    paginator = rds_client.get_paginator('describe_db_snapshots')
    public_snapshots = []

    for page in paginator.paginate(SnapshotType='manual'):
        for snapshot in page["DBSnapshots"]:
            if snapshot.get("PubliclyAccessible"):
                public_snapshots.append(snapshot["DBSnapshotIdentifier"])

    return f"Warning: Public Snapshots Found - {public_snapshots}" if public_snapshots else "No Public Snapshots Found"

def check_deletion_protection(db_instance):
    return "Enabled" if db_instance.get("DeletionProtection") else "Disabled"

def main():
    log_info("Starting RDS Best Practices Check...")
    separator()

    response = rds_client.describe_db_instances()
    db_instances = response["DBInstances"]
    results = []

    for db_instance in db_instances:
        db_identifier = db_instance["DBInstanceIdentifier"]
        log_info(f"Checking RDS Instance: {db_identifier}")
        separator()

        instance_data = {
            "DBInstanceIdentifier": db_identifier,
            "Encryption": check_rds_encryption(db_instance),
            "Public Access": check_public_accessibility(db_instance),
            "Automated Backups": check_automated_backups(db_instance),
            "Multi-AZ Deployment": check_multi_az(db_instance),
            "Instance Type": check_instance_type(db_instance),
            "Idle Status": check_idle_instance(db_instance),
            "Public Snapshot Sharing": check_public_snapshot_sharing(),
            "Deletion Protection": check_deletion_protection(db_instance)
        }

        results.append(instance_data)
        for key, value in instance_data.items():
            log_info(f"{key}: {value}")
        separator()

    # Save results to JSON
    with open("rds_best_practices.json", "w") as file:
        json.dump(results, file, indent=4)

    log_info("Results saved to 'rds_best_practices.json'.")
    log_info("RDS Best Practices Check completed.")
    separator()

if __name__ == "__main__":
    main()

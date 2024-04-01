#! /usr/bin/python3

import sys
import boto3
import os
import configparser
from terraform_output import ecs_cluster_arn, rds_database_arn

# -------------------------
# AWS credentials retrieval
# -------------------------
aws_profile = 'terraform'
aws_access_key_id = None
aws_secret_access_key = None
aws_region = 'eu-west-3'

def get_aws_credentials():
    """
    Gets the AWS credentials from ~/.aws/credentials for
    the terraform profile
    """

    global aws_profile
    global aws_access_key_id
    global aws_secret_access_key

    # Parse the AWS credentials file
    cred_path = ''.join([os.environ['HOME'],"/.aws/credentials"])
    config = configparser.ConfigParser()
    config.read(cred_path)

    # Read AWS access key ID and secret access key
    if aws_profile in config.sections():
        aws_access_key_id = config[aws_profile]['aws_access_key_id']
        aws_secret_access_key = config[aws_profile]['aws_secret_access_key']
    else:
    # If the aws profile does not exist, error and exit
        print(f"Cannot find profile {aws_profile} in {cred_path}")
        sys.exit()

    # If access key ID or secret access key can't be accessed, error and exit
    if aws_access_key_id is None or aws_secret_access_key is None:
        print(f"AWS config values not set in '{aws_profile}' in {cred_path}")
        sys.exit()

# -------------------------
# ECS wordpress task status
# -------------------------
def get_ecs_tasks_status(cluster_arn):
    """
    Create boto3 client for ECS and retrieve ECS wordpress tasks status and health
    Parameters:
        cluster_arn: str
            ARN of the wordpress cluster
    Returns:   
        list[dict]
            List of dictionaries providing task ARN, task status and task health status for each task
    """
    # Create ECS client
    try:
        ecs_client = boto3.client(
            'ecs',
            aws_access_key_id=aws_access_key_id,
            aws_secret_access_key=aws_secret_access_key,
            region_name=aws_region,
        )
    except Exception as e:
        print(e)
        sys.exit()

    # List ECS tasks
    try:
        tasks_list = ecs_client.list_tasks(
        cluster=cluster_arn,
        )
    except ecs_client.exceptions.ClusterNotFoundException as err:
        print(f"Cluster with ARN '{cluster_arn}' not found")
        sys.exit()
    
    tasks_arns = tasks_list['taskArns']

    # Describe ECS tasks
    try:
        tasks_description = ecs_client.describe_tasks(
        cluster=cluster_arn,
        tasks=tasks_arns,
        )
    except ecs_client.exceptions.ClusterNotFoundException as err:
        print(f"Cluster with ARN '{cluster_arn}' not found")
        sys.exit()
    
    tasks_status = [
        {
            'Task ARN': tasks_arns[k],
            'Task status': task['lastStatus'],
            'Task health status': task['healthStatus']
            }
        for k,task in enumerate(tasks_description['tasks'])
    ]
    # print(tasks_status)
    return tasks_status

# ---------------------------
# RDS Database configuration
# ---------------------------
def get_rds_database_config(database_arn):
    """
    Create boto3 client for RDS and retrieve database status and configuration parameters
    Parameters:
        database_arn: str
            ARN of the RDS database
    Returns:   
        dict
            Dictionary providing database instance status, multi-AZ configuration and public access configuration
    """
    # Create RDS client
    try:
        rds_client = boto3.client(
            'rds',
            aws_access_key_id=aws_access_key_id,
            aws_secret_access_key=aws_secret_access_key,
            region_name=aws_region,
        )
    except Exception as e:
        print(e)
        sys.exit()

    # Describe RDS instance
    try:
        db_description = rds_client.describe_db_instances(
        DBInstanceIdentifier=rds_database_arn,
        )
    except rds_client.exceptions.DBInstanceNotFoundFault as err:
        print(f"RDS instance with ARN '{rds_database_arn}' not found")
        sys.exit()

    db = db_description['DBInstances'][0]
    db_status = {
        'Database instance status': db['DBInstanceStatus'],
        'Multi-AZ': db['MultiAZ'],
        'Publicly accessible': db['PubliclyAccessible']
            }
    
    # print(db_status)
    return db_status


# -----------------
# Execute functions
# -----------------
def main():
    get_aws_credentials()
    get_ecs_tasks_status(ecs_cluster_arn)
    get_rds_database_config(rds_database_arn)


if __name__ == '__main__':
    main()
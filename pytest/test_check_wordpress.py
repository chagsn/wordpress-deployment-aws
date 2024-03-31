#! /usr/bin/python3

import sys
import boto3
import os
import configparser
from terraform_output import ecs_cluster_arn, rds_database_arn
from check_wordpress import get_aws_credentials,get_ecs_tasks_status,get_rds_database_config

# ------------------
# AWS authentication
# ------------------
aws_profile = 'terraform'
aws_access_key_id = None
aws_secret_access_key = None
aws_region = 'eu-west-3'
get_aws_credentials()

def test_ecs_tasks_status():
    print("Checking ECS Task status...")
    tasks_status = get_ecs_tasks_status(ecs_cluster_arn)
    for task in tasks_status:
        assert task['Task status'] == 'RUNNING', "Task is not running!"
        assert task['Task health status'] == 'HEALTHY', "Task is not healthy!"

def test_rds_database_config():
    print("Checking RDS database status and configuration...")
    rds_config = get_rds_database_config(rds_database_arn)
    assert rds_config['Database instance status'] == 'available', "Database is not available!"
    assert rds_config['Multi-AZ'] == True, "Database is not Multi-AZ!"
    assert rds_config['Publicly accessible'] == False, "Database is publicly accessible!"


from __future__ import print_function
import boto3
import time
import os

def put_cpu_alarm(instance_id):
    region=os.environ['AWS_DEFAULT_REGION']
    cloudWatch   = boto3.client('cloudwatch')
    cloudWatch.put_metric_alarm(
        AlarmName          = f'CPU_ALARM_{instance_id}',
        AlarmDescription   = 'Alarm when server CPU does not exceed 0.5%',
        AlarmActions       = ['arn:aws:automate:'+region+':ec2:stop'],
        MetricName         = 'CPUUtilization',
        Namespace          = 'AWS/EC2' ,
        Statistic          = 'Maximum',
        Dimensions         = [{'Name': 'InstanceId', 'Value': instance_id}],
        Period             = 300,
        EvaluationPeriods  = 12,
        Threshold          = 0.5,
        ComparisonOperator = 'LessThanOrEqualToThreshold',
        TreatMissingData   = 'notBreaching'
    )

def lambda_handler(event, context):
    instance_id = event['detail']['instance-id']
    ec2 = boto3.resource('ec2')
    instance = ec2.Instance(instance_id)
    cluster_flag = 0
    time.sleep(60)
    try:
        for tags in instance.tags:
            if tags["Key"] == 'aws:cloudformation:stack-id':
                print('It is a Cluster..no action needed.')
                cluster_flag = 1
                break
    except:
        print('No tags')
    finally:    
        if cluster_flag == 0:
            print('Non cluster instance of type', instance.instance_type)
            print('Setup an Alarm ..', instance.instance_type)
            put_cpu_alarm(instance_id)

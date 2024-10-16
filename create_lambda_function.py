import json
import boto3
import os

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    response = ec2.run_instances(
        ImageId=os.environ['AMI_IMAGE_ID'],
        InstanceType='t2.micro',
        MinCount=1,
        MaxCount=1,
        KeyName='ec2-key-pair',
        SubnetId=os.environ['SUBNET_ID'],
        SecurityGroupIds=[os.environ['SECURITY_GROUP_ID']]
    )
    instance_id = response['Instances'][0]['InstanceId']
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Instance created',
            'instance_id': instance_id,
            'ssh_key': 'ec2-key-pair.pem'
        })
    }

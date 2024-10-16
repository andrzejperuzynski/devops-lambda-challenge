import json
import boto3
import os

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    instance_id = event['queryStringParameters'].get('instance_id')
    ec2.start_instances(InstanceIds=[instance_id])
    instance_info = ec2.describe_instances(InstanceIds=[instance_id])
    print(instance_info)
    public_ip = instance_info['Reservations'][0]['Instances'][0]['PublicIpAddress']
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Instance started',
            'instance_id': instance_id,
            'publicIP': public_ip,
            'connect-using-ssh': 'ssh -i ec2-key-pair.pem ec2-user@' + public_ip
        })
    }
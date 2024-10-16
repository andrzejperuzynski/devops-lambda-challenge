import json
import boto3

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    instance_id = event['queryStringParameters'].get('instance_id')
    ec2.terminate_instances(InstanceIds=[instance_id])
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Instance terminated',
            'instance_id': instance_id
        })
    }

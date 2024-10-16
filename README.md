# devops-lambda-challenge

# RUN

## Create new instance of EC2
In terminal type:
```
curl -X GET "https://<API_ID>.execute-api.us-west-2.amazonaws.com/prod/ec2/create"
```

Expected Output:
```
```

## Start selected EC2 instance
In terminal type:
```
curl -X GET "https://<API_ID>.execute-api.us-west-2.amazonaws.com/prod/ec2/start?instance_id=<INSTANCE_ID>"
```

Expected Output:
```
```

## Stop selected EC2 instance
In terminal type:
```
curl -X GET "https://<API_ID>.execute-api.us-west-2.amazonaws.com/prod/ec2/stop?instance_id=<INSTANCE_ID>"
```

Expected Output:
```
```

## Destroy selected EC2 instance
In terminal type:
```
curl -X GET "https://<API_ID>.execute-api.us-west-2.amazonaws.com/prod/ec2/delete?instance_id=<INSTANCE_ID>"
```

Expected Output:
```
```
# devops-lambda-challenge

# RUN

## Create new instance of EC2
In terminal type:
```
curl -X GET "https://<API_ID>.execute-api.us-west-2.amazonaws.com/prod/ec2/create"
```

Expected Output:
```
{"message": "Instance created", "instance_id": "i-0d283554f57ca8903", "ssh_key": "ec2-key-pair.pem"}
```

## Start selected EC2 instance
In terminal type:
```
curl -X GET "https://<API_ID>.execute-api.us-west-2.amazonaws.com/prod/ec2/start?instance_id=<INSTANCE_ID>"
```

Expected Output:
```
{"message": "Instance started", "instance_id": "i-0d283554f57ca8903", "publicIP": "35.89.121.36", "connect-using-ssh": "ssh -i ec2-key-pair.pem ec2-user@35.89.121.36"}
```

### SSH Connection to EC2

Like you can see to connect to `ec2` using `ssh` you can simply copy/paste to terminal content of attribute `connect-using-ssh`.
In this case it's: `ssh -i ec2-key-pair.pem ec2-user@35.89.121.36`.

Expected succeed output:

```
   ,     #_
   ~\_  ####_        Amazon Linux 2
  ~~  \_#####\
  ~~     \###|       AL2 End of Life is 2025-06-30.
  ~~       \#/ ___
   ~~       V~' '->
    ~~~         /    A newer version of Amazon Linux is available!
      ~~._.   _/
         _/ _/       Amazon Linux 2023, GA and supported until 2028-03-15.
       _/m/'           https://aws.amazon.com/linux/amazon-linux-2023/


```

### Possible error during first run of ssh with ec2-key-pair.pem key 
It's possible that you will have the following error:
```
Bad permissions. Try removing permissions for user: NT AUTHORITY\\Authenticated Users on file ec2-key-pair.pem.
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Permissions for 'ec2-key-pair.pem' are too open.
It is required that your private key files are NOT accessible by others.
This private key will be ignored.
Load key "ec2-key-pair.pem": bad permissions
ec2-user@35.89.121.36: Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
```
In that case go to file **properties**, select **Security** tab and make you that all users besides you doesn't have permission to `ec2-key-pair.pem`.
After that try again.

## Stop selected EC2 instance
In terminal type:
```
curl -X GET "https://<API_ID>.execute-api.us-west-2.amazonaws.com/prod/ec2/stop?instance_id=<INSTANCE_ID>"
```

Expected Output:
```
{"message": "Instance stopped", "instance_id": "i-0d283554f57ca8903"}
```

## Destroy selected EC2 instance
In terminal type:
```
curl -X GET "https://<API_ID>.execute-api.us-west-2.amazonaws.com/prod/ec2/delete?instance_id=<INSTANCE_ID>"
```

Expected Output:
```
{"message": "Instance terminated", "instance_id": "i-0d283554f57ca8903"}
```

# Cleaning cloud

```shell
 terraform destroy
```
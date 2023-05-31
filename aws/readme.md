# AWS
> infra-as-code of aws, using awscli and cloud formation

## AWSCLI
Installer
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
verify
```
which aws
aws --version
```

### ACCOUNT SETUP
```
aws configure
```
This will prompt you to enter the following details:

- AWS Access Key ID
- AWS Secret Access Key
- Default region name
- Default output format
Enter the appropriate values for each field.

Verify
```
aws sts get-caller-identity
```
### IAM AWS
You can configure multiple profiles in the AWS CLI configuration file (`~/.aws/config`).
```yaml
[profile account1]
region = us-east-1
aws_access_key_id = AKI****************
aws_secret_access_key = jx*********************

[profile account2]
region = us-west-2
aws_access_key_id = AKI****************
aws_secret_access_key = jx*********************
```
When you run AWS CLI commands, specify the profile using the `--profile`
```bash
aws s3 ls --profile account1
aws ec2 describe-instances --profile account2
```

To set default profile add this to you env 
```
export AWS_DEFAULT_PROFILE=profile_name
```



### GET
**GET ALL USERS**
```bash
aws iam list-users --output table --query 'Users[*].[UserName,UserId,CreateDate]'          
```
```
------------------------------------------------------------------------------------------------
|                                           ListUsers                                          |
+--------------------------------------+-------------------------+-----------------------------+
|  awsdev-0                            |  AIDAUXwwwwwwwwwwwwwww  |  2020-12-15T19:22:23+00:00  |
|  awsadmin                            |  AIDAUXwwwwwwwwwwwwwww  |  2022-09-01T12:17:33+00:00  |
+--------------------------------------+-------------------------+-----------------------------+

```

**INSPECT USER**
```
AWS_USER=jeanandrewfuentes@gmail.com
aws iam list-user-policies --user-name $AWS_USER
aws iam list-groups-for-user --user-name $AWS_USER
aws iam list-user-tags --user-name $AWS_USER
aws iam list-attached-user-policies --user-name $AWS_USER | jq '.AttachedPolicies[].PolicyName | select(. == "AdministratorAccess")'
```

**GET ALL VMS in region** 
```bash
REGION=us-east-2
aws ec2 describe-instances --query 'Reservations[].Instances[].{InstanceId:InstanceId, Name: Tags[?Key==`Name`]|[0].Value, PrivateIP: PrivateIpAddress, PublicIpAddress:PublicIpAddress, Size: InstanceType, PublicDNS: PublicDnsName}' --output table --region $REGION
```
output:
```
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|                                                                            DescribeInstances                                                                            |
+---------------------+-----------------------------------------+-----------------+------------------------------------------------------+------------------+-------------+
|     InstanceId      |                  Name                   |    PrivateIP    |                      PublicDNS                       | PublicIpAddress  |    Size     |
+---------------------+-----------------------------------------+-----------------+------------------------------------------------------+------------------+-------------+
|  i-07302ef6cad6e0336|  NAME-000000000                         |  172.31.23.39   |  ec2-3-21-39-000.us-east-2.compute.amazonaws.com     |  3.21.39.000     |  t2.small   |
|  i-04beac3fefb91544e|  NAME-0000                              |  172.31.29.161  |  ec2-18-223-98-000.us-east-2.compute.amazonaws.com   |  18.223.98.000   |  t2.medium  |
+---------------------+-----------------------------------------+-----------------+------------------------------------------------------+------------------+-------------+

```


**GET ALL ECR in region**

```bash
REGION=us-east-2
#aws ecr describe-repositories --region $REGION --output table 
aws ecr describe-repositories --output table --query 'repositories[*].[registryId, repositoryName, repositoryUri]' --region $REGION
aws ecr describe-repositories --output table --query 'repositories[*].[repositoryUri]' --region $REGION
```


**LOGIN TO YOUR ECR**
```
REGION=us-east-2
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text --region $REGION) # Test this first
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.us-east-2.amazonaws.com
```

### UPDATE 

**GIVE ADMIN ACCESS TO USER**
```bash
USER=admin@example.com
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --user-name $USER
```

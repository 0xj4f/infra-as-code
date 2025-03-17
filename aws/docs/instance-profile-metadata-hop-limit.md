# EC2 Instance Profile with IMDSv2 and S3 Access Cheatsheet  

## 1. Create IAM Role for EC2 Instance Profile  
Create an IAM role that allows EC2 to assume the role.  

```bash
aws iam create-role --role-name S3AccessEC2Role --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": { "Service": "ec2.amazonaws.com" },
            "Action": "sts:AssumeRole"
        }
    ]
}'
```

## 2. Attach S3 Permissions to the Role  
Grant read/write access to a specific S3 bucket.  

```bash
aws iam put-role-policy --role-name S3AccessEC2Role --policy-name S3AccessPolicy --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::MyBucket",
                "arn:aws:s3:::MyBucket/*"
            ]
        }
    ]
}'
```
Replace `MyBucket` with the actual bucket name.  

## 3. Create and Attach Instance Profile  
Create an instance profile and attach the role.  

```bash
aws iam create-instance-profile --instance-profile-name S3AccessInstanceProfile
aws iam add-role-to-instance-profile --instance-profile-name S3AccessInstanceProfile --role-name S3AccessEC2Role
```

## 4. Launch EC2 and Attach the Profile  
Run an EC2 instance with the instance profile.  

```bash
aws ec2 run-instances \
    --image-id ami-xxxxxxxxxxxxxxxxx \
    --count 1 \
    --instance-type t2.micro \
    --iam-instance-profile Name=S3AccessInstanceProfile \
    --subnet-id subnet-xxxxxxxx \
    --security-group-ids sg-xxxxxxxx \
    --key-name MyKeyPair
```
Replace `ami-xxxxxxxxxxxxxxxxx`, `subnet-xxxxxxxx`, `sg-xxxxxxxx`, and `MyKeyPair` with actual values.  

## 5. Enable Metadata and Set Hop Limit for Containers  
Modify the instance metadata settings to enforce IMDSv2 and allow access for containers.  

```bash
aws ec2 modify-instance-metadata-options \
    --instance-id i-xxxxxxxxxxxxx \
    --http-endpoint enabled \
    --http-tokens required \
    --http-put-response-hop-limit 2
```
Replace `i-xxxxxxxxxxxxx` with the actual instance ID.  

## 6. Fetch AWS Credentials from EC2 Metadata  
Use the following script to retrieve and configure AWS credentials dynamically.  

```bash
#!/bin/bash

IAM_ROLE="S3AccessEC2Role"

# Fetch IMDSv2 Token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Get temporary AWS credentials
AWS_CREDENTIALS=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  "http://169.254.169.254/latest/meta-data/iam/security-credentials/$IAM_ROLE")

# Extract Keys
AWS_ACCESS_KEY_ID=$(echo $AWS_CREDENTIALS | jq -r '.AccessKeyId')
AWS_SECRET_ACCESS_KEY=$(echo $AWS_CREDENTIALS | jq -r '.SecretAccessKey')
AWS_SESSION_TOKEN=$(echo $AWS_CREDENTIALS | jq -r '.Token')

# Validate if keys were retrieved successfully
if [[ -z "$AWS_ACCESS_KEY_ID" || -z "$AWS_SECRET_ACCESS_KEY" || -z "$AWS_SESSION_TOKEN" ]]; then
  echo "Failed to retrieve AWS credentials. Exiting."
  exit 1
fi

# Create or update ~/.aws/credentials
AWS_CREDENTIALS_FILE="$HOME/.aws/credentials"

mkdir -p "$HOME/.aws"

cat << EOF > "$AWS_CREDENTIALS_FILE"
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
aws_session_token = $AWS_SESSION_TOKEN
EOF

# Set permissions
chmod 600 "$AWS_CREDENTIALS_FILE"
echo $AWS_CREDENTIALS_FILE
cat $AWS_CREDENTIALS_FILE
```

## 7. Verify S3 Access from EC2  

Check if the instance profile is attached:  

```bash
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/
```

List objects in the S3 bucket:  

```bash
aws s3 ls s3://MyBucket
```

Download a file:  

```bash
aws s3 cp s3://MyBucket/sample.txt .
```

Upload a file:  

```bash
aws s3 cp myfile.txt s3://MyBucket/
```

## Key Takeaways  
- Use an IAM role instead of static credentials.  
- Enable IMDSv2 and set hop limit to 2 for containers.  
- Fetch temporary credentials dynamically from instance metadata.  
- Use the retrieved credentials to interact with S3 securely.  

Memorization Trick:
“ROLE → PROFILE → ATTACH → ENABLE METADATA → TEST”

-️ Create Role (S3AccessEC2Role)
-️ Give Role Permissions (S3AccessPolicy)
-️ Create Instance Profile (S3AccessInstanceProfile)
-️ Attach Role to Profile & Launch EC2
-️ Enable Metadata & Hop Limit for Containers
-️ Test Access with Metadata & S3 Commands


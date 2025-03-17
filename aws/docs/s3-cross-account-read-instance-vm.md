# **S3 Cross-Account EC2 Instance Profile Cheatsheet**  

### **Scenario:**  
- **Account A** owns the **S3 bucket**.  
- **Account B** has an **EC2 instance** with an **IAM role** (Instance Profile).  
- The **EC2 instance in Account B** needs to access the **S3 bucket in Account A**.  

---

### **1. Create an IAM Role for the EC2 Instance in Account B**  
Create an IAM role in **Account B** for the EC2 instance and attach the following **IAM policy**:  

```json
{
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
                "arn:aws:s3:::AccountABucketName",
                "arn:aws:s3:::AccountABucketName/*"
            ]
        }
    ]
}
```
- Replace `AccountABucketName` with the actual bucket name.
- This allows the EC2 instance in **Account B** to read/write objects in **Account A’s bucket**.

---

### **2. Attach IAM Role to the EC2 Instance in Account B**  
- Create an EC2 instance in **Account B**.  
- Attach the IAM role created above as its **Instance Profile**.  

```bash
aws ec2 associate-iam-instance-profile --instance-id i-xxxxxx --iam-instance-profile Name=EC2S3AccessRole
```

---

### **3. Modify Bucket Policy in Account A**  
In **Account A**, update the **S3 bucket policy** to allow access from the **IAM role in Account B**:  

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::AccountB:role/EC2S3AccessRole"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::AccountABucketName",
                "arn:aws:s3:::AccountABucketName/*"
            ]
        }
    ]
}
```
- Replace `AccountB` with the actual **AWS account ID** of **Account B**.  
- Replace `EC2S3AccessRole` with the actual **IAM role name** attached to the EC2 instance.  

---

### **4. Test S3 Access from the EC2 Instance in Account B**  
From **Account B's EC2 instance**, retrieve credentials from **instance metadata**:  

```bash
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/
```

Test access to **Account A's S3 bucket**:  

```bash
aws s3 ls s3://AccountABucketName --region us-east-1
```

Download a file:  

```bash
aws s3 cp s3://AccountABucketName/sample.txt .
```

Upload a file:  

```bash
aws s3 cp myfile.txt s3://AccountABucketName/
```

---

### **Key Takeaways**  
- **IAM Role in Account B** must have **S3 permissions**.  
- **Bucket Policy in Account A** must allow the IAM role from **Account B**.  
- **EC2 instance profile** provides temporary credentials to **assume the role**.  
- **Use instance metadata (`169.254.169.254`)** to check role permissions.  
- **No need for access keys**; authentication is handled via instance profile.

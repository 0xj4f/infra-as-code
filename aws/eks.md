# EKS

verify your aws account first
```
aws sts get-caller-identity   
```
list the available clusters
```
aws eks list-clusters 
```

describe the cluster you want
```
aws eks describe-cluster --name clusterName --region us-east-2     
```
save config 
```
aws eks update-kubeconfig --region us-east-2 --name clusterName
#or  
aws eks get-token --region us-east-2 --cluster-name clusterName

```

verify
```
kubectl config view
```
## EKS POLICY 

eks admin
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        }
    ]
}
```
eks user
```json
{
    "Effect":"Allow"
    "Action": [
        "eks:DescribeNodegroup",
        "eks: ListNodegroups",
        "eks: DescribeCluster",
        "eks: ListClusters",
        "eks: AccessKubernetesApi",
        "ssm:GetParameter",
        "eks: ListUpdates",
        "eks:ListFargateProfiles"
    ],
    "Resource": "*"
}
```

## AWS Authenticator
```
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
aws-iam-authenticator help
```


## References:
- https://betterprogramming.pub/kubernetes-authentication-in-aws-eks-using-iam-authenticator-de3a586e885c

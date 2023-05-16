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
    "eks:DescribeNodegroup".
    "eks: ListNodegroups"
    "eks: DescribeCluster"
    "eks: ListClusters"
    "eks: AccessKubernetesApi"
    "ssm:GetParameter"
    "eks: ListUpdates"
    "eks:ListFargateProfiles"
],
"Resource": "*"
}
```

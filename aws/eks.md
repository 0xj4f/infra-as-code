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

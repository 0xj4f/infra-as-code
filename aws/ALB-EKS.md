# AWS Application Load Balancer for EKS
> Requirements there should be an existing EKS already


## Create IAM Policies

download latest policy: https://github.com/kubernetes-sigs/aws-load-balancer-controller/tree/main/docs/install 
```
curl -o iam_policy_latest.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
```

then create the policy
```
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy_latest.json
```

to fetch the policy
```bash
aws iam list-policies --query "Policies[?PolicyName=='AWSLoadBalancerControllerIAMPolicy']"
```

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

## Create IAM role for AWS LoadBalancer Controller

template
```
eksctl create iamserviceaccount \
  --cluster=my_cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \ #Note:  K8S Service Account Name that need to be bound to newly created IAM Role
  --attach-policy-arn=arn:aws:iam::111122223333:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve
```
response
```
2023-05-17 15:14:59 [ℹ]  1 task: { 
    2 sequential sub-tasks: { 
        create IAM role for serviceaccount "kube-system/aws-load-balancer-controller",
        create serviceaccount "kube-system/aws-load-balancer-controller",
    } }2023-05-17 15:14:59 [ℹ]  building iamserviceaccount stack "eksctl-thetoast-io-addon-iamserviceaccount-kube-system-aws-load-balancer-controller"
2023-05-17 15:14:59 [ℹ]  deploying stack "eksctl-thetoast-io-addon-iamserviceaccount-kube-system-aws-load-balancer-controller"
2023-05-17 15:15:00 [ℹ]  waiting for CloudFormation stack "eksctl-thetoast-io-addon-iamserviceaccount-kube-system-aws-load-balancer-controller"
2023-05-17 15:15:31 [ℹ]  waiting for CloudFormation stack "eksctl-thetoast-io-addon-iamserviceaccount-kube-system-aws-load-balancer-controller"
2023-05-17 15:15:33 [ℹ]  created serviceaccount "kube-system/aws-load-balancer-controller"
```

verify in eksctl
```
╰─$ eksctl get iamserviceaccount --cluster=eks-clustername
NAMESPACE       NAME                            ROLE ARN
kube-system     aws-load-balancer-controller    arn:aws:iam::11111111:role/eksctl-thetoast-io-addon-iamserviceaccount-k-Role1-11111111
```

verify in kubectl
```
kubectl get sa aws-load-balancer-controller -n kube-system
kubectl describe sa aws-load-balancer-controller -n kube-system
```
response
```
Name:                aws-load-balancer-controller
Namespace:           kube-system
Labels:              app.kubernetes.io/managed-by=eksctl
Annotations:         eks.amazonaws.com/role-arn: arn:aws:iam::11111111:role/eksctl-thetoast-io-addon-iamserviceaccount-k-Role1-11111111
Image pull secrets:  <none>
Mountable secrets:   <none>
Tokens:              <none>
Events:              <none>
```


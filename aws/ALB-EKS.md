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



## Install load balancer using helm

```
helm version
version.BuildInfo{Version:"v3.11.0", GitCommit:"472c5736ab01133de504a826bd9ee12cbe4e7904", GitTreeState:"clean", GoVersion:"go1.19.5"}
```

> get region code here: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html  
> us-east-2	602401143452.dkr.ecr.us-east-2.amazonaws.com


helm repo add eks https://aws.github.io/eks-charts
helm repo update

```
## Template
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=<cluster-name> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=<region-code> \
  --set vpcId=<vpc-xxxxxxxx> \
  --set image.repository=<account>.dkr.ecr.<region-code>.amazonaws.com/amazon/aws-load-balancer-controller
```

response 
```
NAME: aws-load-balancer-controller
LAST DEPLOYED: Wed May 17 15:32:41 2023
NAMESPACE: kube-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
AWS Load Balancer controller installed!
```

verify in kubectl
```
kubectl -n kube-system describe deployment aws-load-balancer-controller
Name:                   aws-load-balancer-controller
Namespace:              kube-system
CreationTimestamp:      Wed, 17 May 2023 15:32:49 +0800
Labels:                 app.kubernetes.io/instance=aws-load-balancer-controller
                        app.kubernetes.io/managed-by=Helm
                        app.kubernetes.io/name=aws-load-balancer-controller
                        app.kubernetes.io/version=v2.5.1
                        helm.sh/chart=aws-load-balancer-controller-1.5.2
Annotations:            deployment.kubernetes.io/revision: 1
                        meta.helm.sh/release-name: aws-load-balancer-controller
                        meta.helm.sh/release-namespace: kube-system
Selector:               app.kubernetes.io/instance=aws-load-balancer-controller,app.kubernetes.io/
...
```

verify in pods
```
╰─$ k -n kube-system get pods            
NAME                                            READY   STATUS    RESTARTS   AGE
aws-load-balancer-controller-7c8887dc4f-74llm   1/1     Running   0          11m
aws-load-balancer-controller-7c8887dc4f-cbz6n   1/1     Running   0          11m
```



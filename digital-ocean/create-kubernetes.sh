#!/bin/bash

# Set variables for number of nodes, amount of RAM, amount of CPU, and name of cluster
# NODE=1
# RAM=4
# CPU=2
# NAME=doks-poc
# REGION=sgp1 # singapore

NODE=1
RAM=2
CPU=2
NAME=doks-poc
REGION=sgp1 # singapore
DOKS_VERSION=1.25.4-do.0
NAMESPACE=APP
# Create the Kubernetes cluster
set -x
doctl kubernetes cluster create $NAME \
  --count $NODE \
  --size "s-${CPU}vcpu-${RAM}gb" \
  --version $DOKS_VERSION \
  --region $REGION

# echo "Please enter a value: "
# read TOKEN
# doctl k8s cluster kubeconfig save $TOKEN 

# doctl compute load-balancer create --name doks-poc-lb --region sgp1 --tag-name doks-poc --forwarding-rules "protocol:http,entry_port:80,target_port:80,entry_protocol:http,target_protocol:http"


# doctl compute load-balancer list-ip-addresses --load-balancer-id $(doctl compute load-balancer list --tag-name doks-poc --format ID) 
# --format PublicIPv4 | xargs doctl kubernetes cluster-attach-ip doks-poc
#  doctl compute load-balancer list --format ID                                                                                                                                                                  255 ↵
# ID
# 8a1f6be7-afd2-4408-b1ae-6d005cbe40a8

# Create Namespace
kubectl create namespace $NAMESPACE

# Create example Application
kubectl run test-server --image=gcr.io/google_containers/echoserver:1.8 -n $NAMESPACE
kubectl expose pod test-server --type=NodePort --port=80 --target-port=8080 -n $NAMESPACE
kubectl get po,svc -n $NAMESPACE


helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# Get latest
helm repo update
# install nginx-ingress
helm install nginx-ingress ingress-nginx/ingress-nginx --set controller.publishService.enabled=true

echo "[!] Wait for EXTERNAL-IP : 3-5 mins..." 
kubectl --namespace default get services -o wide -w nginx-ingress-ingress-nginx-controller
kubectl apply -f ingress-app.yaml -n app
#146.190.202.164
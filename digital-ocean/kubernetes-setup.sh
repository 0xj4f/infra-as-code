#!/bin/bash


# Create Namespace
kubectl create namespace $NAMESPACE

# Create example Application
kubectl run test-server --image=gcr.io/google_containers/echoserver:1.8 -n $NAMESPACE
kubectl expose pod test-server --type=NodePort --port=80 --target-port=8080 -n $NAMESPACE


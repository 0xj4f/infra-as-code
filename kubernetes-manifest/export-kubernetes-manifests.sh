#!/bin/bash

# Define the namespace
NAMESPACE="your-namespace"

# Create a directory to store the manifests
EXPORT_DIR=$(date +%Y%m%d)
mkdir -p "${EXPORT_DIR}"
# Export all the manifests
kubectl get all -n "${NAMESPACE}" -o yaml > "${EXPORT_DIR}/all.yaml"
kubectl get configmap -n "${NAMESPACE}" -o yaml > "${EXPORT_DIR}/configmaps.yaml"
kubectl get secret -n "${NAMESPACE}" -o yaml > "${EXPORT_DIR}/secrets.yaml"
kubectl get ingress -n "${NAMESPACE}" -o yaml > "${EXPORT_DIR}/ingresses.yaml"
kubectl get service -n "${NAMESPACE}" -o yaml > "${EXPORT_DIR}/services.yaml"
kubectl get deployment -n "${NAMESPACE}" -o yaml > "${EXPORT_DIR}/deployments.yaml"
kubectl get statefulset -n "${NAMESPACE}" -o yaml > "${EXPORT_DIR}/statefulsets.yaml"
kubectl get daemonset -n "${NAMESPACE}" -o yaml > "${EXPORT_DIR}/daemonsets.yaml"
kubectl get job -n "${NAMESPACE}" -o yaml > "${EXPORT_DIR}/jobs.yaml"
kubectl get cronjob -n "${NAMESPACE}" -o yaml > "${EXPORT_DIR}/cronjobs.yaml"

# Print the export completion message
echo "Kubernetes manifests exported to ${EXPORT_DIR}"

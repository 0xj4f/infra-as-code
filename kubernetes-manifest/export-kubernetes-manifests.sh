#!/bin/bash

# Get all namespaces
namespaces=($(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}'))

# Iterate over each namespace
for namespace in "${namespaces[@]}"; do
  echo "Exporting namespace: $namespace"

  # Create a directory with the current date and namespace
  export_dir=$(date +%Y%m%d)"-$namespace"
  mkdir -p "$export_dir"

  # Export all the manifests for the namespace
  kubectl get all -n "$namespace" -o yaml > "$export_dir/all.yaml"
  kubectl get configmap -n "$namespace" -o yaml > "$export_dir/configmaps.yaml"
  kubectl get secret -n "$namespace" -o yaml > "$export_dir/secrets.yaml"
  kubectl get ingress -n "$namespace" -o yaml > "$export_dir/ingresses.yaml"
  kubectl get service -n "$namespace" -o yaml > "$export_dir/services.yaml"
  kubectl get deployment -n "$namespace" -o yaml > "$export_dir/deployments.yaml"
  kubectl get statefulset -n "$namespace" -o yaml > "$export_dir/statefulsets.yaml"
  kubectl get daemonset -n "$namespace" -o yaml > "$export_dir/daemonsets.yaml"
  kubectl get job -n "$namespace" -o yaml > "$export_dir/jobs.yaml"
  kubectl get cronjob -n "$namespace" -o yaml > "$export_dir/cronjobs.yaml"

  echo "Kubernetes manifests exported to $export_dir"
done

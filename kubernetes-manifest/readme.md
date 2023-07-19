# Kubernetes

## Cluster Management

```
# list all context
kubectl config get-contexts

# switch to context
kubectl config use-context $CLUSTER_A

# verify
kubectl config current-context
```

## Ubuntu Pod

Here are some commands you can use with `kubectl` to debug and check network access:

1. Check cluster information:
   - `kubectl cluster-info`: Displays cluster information, including the Kubernetes master and services.

2. Check nodes and pods:
   - `kubectl get nodes`: Lists all the nodes in the cluster.
   - `kubectl get pods`: Lists all the pods in the cluster.
   - `kubectl describe node <node-name>`: Provides detailed information about a specific node.
   - `kubectl describe pod <pod-name>`: Provides detailed information about a specific pod.

3. Check network connectivity:
   - `kubectl exec -it <pod-name> -- ping <destination>`: Runs a `ping` command from a pod to a specific destination to check network connectivity.
   - `kubectl exec -it <pod-name> -- curl <destination>`: Executes a `curl` command from a pod to a specific destination to check network access.

4. Check pod logs:
   - `kubectl logs <pod-name>`: Retrieves the logs of a specific pod.
   - `kubectl logs -f <pod-name>`: Streams the logs of a specific pod in real-time.

5. Port forwarding:
   - `kubectl port-forward <pod-name> <local-port>:<pod-port>`: Forwards a local port to a specific port on a pod, allowing you to access the pod's service locally.

6. Exec into a pod:
   - `kubectl exec -it <pod-name> -- /bin/sh`: Opens an interactive shell session inside a pod for debugging purposes.

These are just a few examples of using `kubectl` for debugging and network checks. `kubectl` provides many more commands and options for interacting with Kubernetes clusters.


## NGINX INGRESS
https://kubernetes.github.io/ingress-nginx/user-guide/ingress-path-matching/

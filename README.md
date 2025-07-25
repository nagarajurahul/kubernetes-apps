# Kubernetes Pod Failure and Lifecycle Troubleshooting Guide

This guide outlines the key failure scenarios and troubleshooting approaches for common pod lifecycle issues in Kubernetes, tailored for DevOps, Cloud Engineers, and SRE professionals.

---

## 📌 1. Pod Not Scheduled

### Causes
- **Insufficient resources (CPU/Memory)**
- **Node selectors or affinity rules not met**
- **Taints without matching tolerations**
- **Pod topology spread constraints**
- **Node is unschedulable (cordoned)**
- **PodDisruptionBudget preventing scheduling**
- **Volume node affinity not matched**

### Troubleshooting
```bash
kubectl describe pod <pod-name>
kubectl get nodes -o wide
kubectl get events --sort-by=.metadata.creationTimestamp
```

---

## 🧱 2. Pod Stuck in ContainerCreating

### Causes
- **Image pull delay or failure**
- **PersistentVolumeClaim pending or unbound**
- **Init containers not completed**
- **CNI network setup issues**
- **TLS or secret/configMap volume mount failure**
- **SecurityContext/permissions issues**
- **Container runtime slowness or failure**

### Troubleshooting
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name> -c <init-container>
kubectl get pvc
```

---

## 🚀 3. Pod Stuck on Init Containers

### Causes
- **Init container command fails (non-zero exit)**
- **Missing image or pull error**
- **Volume or network dependencies not ready**
- **Configuration errors (env vars, secrets, etc.)**

### Troubleshooting
```bash
kubectl logs <pod-name> -c <init-container-name>
kubectl describe pod <pod-name>
```

---

## 🖼️ 4. Pod in ImagePullBackOff

### Causes
- **Wrong image name or tag**
- **Private registry without proper imagePullSecrets**
- **DockerHub rate limits**
- **Network/DNS issues**
- **Registry authentication failure**

### Troubleshooting
```bash
kubectl describe pod <pod-name>
kubectl get secret
kubectl get events --sort-by=.metadata.creationTimestamp
```

---

## 🔄 5. Pod in CrashLoopBackOff

### Causes
- **App exits with error (non-zero code)**
- **Startup/Liveness probes failing**
- **Missing config/secret/env**
- **Insufficient memory (OOMKilled)**
- **Bad entrypoint or CMD**

### Troubleshooting
```bash
kubectl logs <pod-name> -c <container-name>
kubectl describe pod <pod-name>
kubectl get pod <pod-name> -o jsonpath='{.status.containerStatuses[*].state.terminated.exitCode}'
```

---

## 🛑 6. Pod Stuck in Terminating

### Causes
- **Finalizers not completing**
- **Node is unresponsive**
- **Volume detachment issues (EBS/NFS)**
- **Hanging preStop hook**
- **Container ignores SIGTERM**

### Troubleshooting
```bash
kubectl get pod <pod-name> -o json | jq '.metadata.finalizers'
kubectl delete pod <pod-name> --grace-period=0 --force
journalctl -u kubelet
```

---

## ✅ Best Practices
- Use **readiness and liveness probes** wisely
- Always **specify resource requests/limits**
- Monitor **image pull and registry access**
- Use **structured logging** for better observability
- Implement **graceful shutdown handlers** in apps
- Regularly audit **init containers, secrets, and volumes**

---

This guide is designed to be a quick reference for real-world Kubernetes troubleshooting, especially in production cloud environments like AWS (EKS), GCP (GKE), and IBM Cloud (IKS).

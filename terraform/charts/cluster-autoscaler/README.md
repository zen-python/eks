```
helm repo add autoscaler https://kubernetes.github.io/autoscaler
helm repo update
helm install cluster-autoscaler --namespace kube-system autoscaler/cluster-autoscaler-chart --values=values.yaml
```

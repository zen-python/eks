```
helm repo add external-secrets https://external-secrets.github.io/kubernetes-external-secrets/
helm repo update
helm install external-secrets/kubernetes-external-secrets -f values.yaml
```

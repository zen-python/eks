```
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install aws nginx-stable/nginx-ingress -f values.yaml
```

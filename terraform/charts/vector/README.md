helm repo add timberio https://packages.timber.io/helm/latest
helm show values timberio/vector-agent
cat <<-'VALUES' > values.yaml
# The Vector Kubernetes integration automatically defines a
# kubernetes_logs source that is made available to you.
# You do not need to define a log source.
sinks:
  # Adjust as necessary. By default we use the console sink
  # to print all data. This allows you to see Vector working.
  # https://vector.dev/docs/reference/sinks/
  stdout:
    type: console
    inputs: ["kubernetes_logs"]
    rawConfig: |
      target = "stdout"
      encoding = "json"
VALUES
helm install --namespace vector --create-namespace vector timberio/vector-agent --values values.yaml
kubectl logs --namespace vector daemonset/vector-agent


kubectl rollout restart --namespace vector daemonset/vector-agent

kubectl logs --namespace vector daemonset/vector-agent
helm repo update && helm upgrade --namespace vector vector timberio/vector-agent --reuse-values

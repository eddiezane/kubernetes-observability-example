**Note** that these instructions require Helm v3. For Helm v2 instructions please see [this branch](https://github.com/eddiezane/kubernetes-observability-example/tree/helm-2.0).

# Install sample app

```
# https://github.com/BuoyantIO/emojivoto
kubectl apply -k "github.com/eddiezane/emojivoto/kustomize/deployment?ref=workshop"
```

# Install Helm

```
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo add loki https://grafana.github.io/loki/charts
helm repo update
```

# Install Prometheus Operator and Grafana

```
kubectl create namespace observability
helm install prom stable/prometheus-operator --namespace observability -f prom-custom-values.yaml
```

# Install Loki

```
helm install loki loki/loki-stack --namespace observability --set loki.persistence.enabled=true --set loki.persistence.size=5Gi --set loki.persistence.storageClassName=do-block-storage
```

# View

```
kubectl port-forward -n observability svc/prom-grafana 8080:80
# Visit http://localhost:8080
# Login with adimin tacocat
# Add Loki data source as http://loki:3100
```

# Cleanup

```
kubectl delete -k "github.com/eddiezane/emojivoto/kustomize/deployment?ref=workshop"
helm delete prom --namespace observability
helm delete loki --namespace observability
kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com
kubectl delete crd podmonitors.monitoring.coreos.com
sleep 5
kubectl delete namespace observability
```

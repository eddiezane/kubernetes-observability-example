# Install sample app

```
# https://github.com/BuoyantIO/emojivoto
kubectl apply -f https://raw.githubusercontent.com/BuoyantIO/emojivoto/master/emojivoto.yml
```

# Install Helm

```
helm repo add loki https://grafana.github.io/loki/charts
helm repo update
kubectl --namespace kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

helm init --upgrade --service-account tiller

# If you installed Helm without the Service Account first
kubectl --namespace kube-system patch deploy tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
```

# Install Prometheus Operator and Grafana

```
helm install --name prom --namespace observability -f prom-custom-values.yaml stable/prometheus-operator
```

# Install Loki

```
helm install --name loki --namespace observability --set loki.persistence.enabled=true --set loki.persistence.size=5Gi --set loki.persistence.storageClassName=do-block-storage loki/loki-stack
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
kubectl delete -f https://raw.githubusercontent.com/BuoyantIO/emojivoto/master/emojivoto.yml
helm delete prom --purge
helm delete loki --purge
kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com
sleep 5
kubectl delete namespace observability
```

cluster:
	doctl kubernetes cluster create doks-observability --region fra1

emoji:
	kubectl apply -k "github.com/eddiezane/emojivoto.git/kustomize/deployment?ref=workshop"

helm:
	helm repo add stable https://kubernetes-charts.storage.googleapis.com/
	helm repo add loki https://grafana.github.io/loki/charts
	helm repo update

prom:
	kubectl create namespace observability
	helm install prom stable/prometheus-operator --namespace observability -f prom-custom-values.yaml

loki:
	helm install loki loki/loki-stack --namespace observability --set loki.persistence.enabled=true --set loki.persistence.size=5Gi --set loki.persistence.storageClassName=do-block-storage

proxy:
	kubectl port-forward -n observability svc/prom-grafana 8080:80

clean:
	kubectl delete -k "github.com/eddiezane/emojivoto.git/kustomize/deployment?ref=workshop"
	helm delete prom --namespace observability
	helm delete loki --namespace observability
	kubectl delete crd prometheuses.monitoring.coreos.com                                                                                                                
	kubectl delete crd prometheusrules.monitoring.coreos.com
	kubectl delete crd servicemonitors.monitoring.coreos.com
	kubectl delete crd alertmanagers.monitoring.coreos.com
	kubectl delete crd podmonitors.monitoring.coreos.com
	sleep 5
	kubectl delete namespace observability

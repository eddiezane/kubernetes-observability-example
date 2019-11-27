cluster:
	doctl kubernetes cluster create k8s-shark-codes --region sfo2 --size s-4vcpu-8gb --count 5 --wait

emoji:
	kubectl apply -k github.com/BuoyantIO/emojivoto.git/kustomize/deployment

helm:
	helm repo add loki https://grafana.github.io/loki/charts
	helm repo update
	kubectl --namespace kube-system create serviceaccount tiller
	kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
	helm init --upgrade --service-account tiller

prom:
	helm install --name prom --namespace observability -f prom-custom-values.yaml stable/prometheus-operator

loki:
	helm install --name loki --namespace observability --set loki.persistence.enabled=true --set loki.persistence.size=5Gi --set loki.persistence.storageClassName=do-block-storage loki/loki-stack

proxy:
	kubectl port-forward -n observability svc/prom-grafana 8080:80

clean:
	kubectl delete -k github.com/BuoyantIO/emojivoto.git/kustomize/deployment
	helm delete prom --purge
	helm delete loki --purge
	kubectl delete crd prometheuses.monitoring.coreos.com                                                                                                                
	kubectl delete crd prometheusrules.monitoring.coreos.com
	kubectl delete crd servicemonitors.monitoring.coreos.com
	kubectl delete crd alertmanagers.monitoring.coreos.com
	kubectl delete crd podmonitors.monitoring.coreos.com
	sleep 5
	kubectl delete namespace observability

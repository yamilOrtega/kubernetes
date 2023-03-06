kubectl create namespace monitoring
kubectl apply -f 00-clusterRole.yaml
kubectl apply -f 01-config-map.yaml
kubectl apply -f 02-prometheus-deployment.yaml
kubectl apply -f 03-prometheus-service.yaml 
kubectl apply -f 04-prometheus-ingress.yaml


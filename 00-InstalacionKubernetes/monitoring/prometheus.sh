kubectl create namespace monitoring
kubectl apply -f 00-clusterRole.yaml
kubectl apply -f clusterRole.yaml
kubectl apply -f 01-config-map.yaml
kubectl apply -f 02-prometheus-deployment.yaml
#Se revisan estatus de cracion
kubectl get deployments --namespace=monitoring -w

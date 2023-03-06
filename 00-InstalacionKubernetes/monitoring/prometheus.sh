kubectl create namespace monitoring
kubectl apply -f 00-PersistentVolume.yaml
kubectl apply -f 01-PersistentVolumeClaim.yaml
kubectl apply -f 03-clusterRole.yaml
kubectl apply -f 04-config-map.yaml
kubectl apply -f 05-prometheus-deployment.yaml
kubectl apply -f 06-prometheus-service.yaml 
kubectl apply -f 07-prometheus-ingress.yaml
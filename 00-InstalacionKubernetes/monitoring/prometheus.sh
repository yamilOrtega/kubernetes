kubectl create namespace monitoring
kubectl apply -f 00-PersistentVolumeConfigVolume.yaml
kubectl apply -f 00-PersistentVolumeStorageVolume.yaml
kubectl apply -f 01-PersistentVolumeClaimConfigVolume.yaml
kubectl apply -f 01-PersistentVolumeClaimStorageVolume.yaml
kubectl apply -f 03-clusterRole.yaml
kubectl apply -f 04-config-map.yaml
kubectl apply -f 05-prometheus-deployment.yaml
kubectl apply -f 06-prometheus-service.yaml 
kubectl apply -f 07-prometheus-ingress.yaml
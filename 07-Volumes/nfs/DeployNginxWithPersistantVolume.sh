kubectl apply -f 01PersistentVolume.yaml
kubectl apply -f 02PersistentVolumeClaim.yaml
kubectl apply -f 03NginxWithPersistentVolumeClaim.yaml
kubectl apply -f 04LoadBalancerServiceForNginxShared.yaml


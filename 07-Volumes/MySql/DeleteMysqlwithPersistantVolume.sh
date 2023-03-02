kubectl delete -f 04Deployment.yaml
kubectl delete -f 03Service.yaml
kubectl delete -f 02PersistentVolumeClaim.yaml
kubectl delete -f 01PersistentVolume.yaml

kubectl delete secret mysql-db-url
kubectl delete secret mysql-user-pass
kubectl delete secret mysql-root-pass 



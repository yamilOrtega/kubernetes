kubectl create secret generic mysql-root-pass --from-literal=password=YUIidhb667

kubectl create secret generic mysql-user-pass --from-literal=username=kodekloud_rin --from-literal=password=BruCStnMT5

kubectl create secret generic mysql-db-url --from-literal=database=kodekloud_db10

kubectl apply -f 01PersistentVolume.yaml
kubectl apply -f 02PersistentVolumeClaim.yaml
kubectl apply -f 03Service.yaml
kubectl apply -f 04Deployment.yaml

kubectl create namespace mongodb-namespace
kubectl apply -f 06-mongoDBSecretWithNS.yaml
kubectl apply -f 07-mongoDBDeploymentWithNS.yaml
kubectl apply -f 08-mongoExpressConfigMapWithNS.yaml
kubectl apply -f 09-mongoExpressDeploymentWithNS.yaml
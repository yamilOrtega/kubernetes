kubectl delete -f 06-mongoDBSecretWithNS.yaml
kubectl delete -f 07-mongoDBDeploymentWithNS.yaml
kubectl delete -f 08-mongoExpressConfigMapWithNS.yaml
kubectl delete -f 09-mongoExpressDeploymentWithNS.yaml
kubectl delete namespace mongodb-namespace
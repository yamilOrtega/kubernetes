kubectl delete -f 06-mongoDBSecretWithIngress.yaml
kubectl delete -f 07-mongoDBDeploymentWithIngress.yaml
kubectl delete -f 08-mongoExpressConfigMapWithIngress.yaml
kubectl delete -f 09-mongoExpressDeploymentWithIngress.yaml
kubectl delete -f 10-IngressRule.yaml
kubectl delete namespace mongodb-ingress-namespace
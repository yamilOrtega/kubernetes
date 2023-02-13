kubectl create namespace mongodb-ingress-namespace
kubectl apply -f 06-mongoDBSecretWithIngress.yaml
kubectl apply -f 07-mongoDBDeploymentWithIngress.yaml
kubectl apply -f 08-mongoExpressConfigMapWithIngress.yaml
kubectl apply -f 09-mongoExpressDeploymentWithIngress.yaml
kubectl apply -f 10-IngressRule.yaml
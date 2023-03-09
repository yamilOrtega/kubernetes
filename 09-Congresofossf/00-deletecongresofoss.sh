kubectl delete -f 02-congresofoss-ingress.yaml
kubectl delete -f 04-congresofoss-ingress-tls.yaml
kubectl delete namespace congresofoss-namespace
kubectl delete secret acr-auth
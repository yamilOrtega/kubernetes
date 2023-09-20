kubectl delete -f 04-hello-ingress-tls.yaml
kubectl delete -f 03.1-Certificate.yaml
kubectl delete -f 03-issuer.yaml
kubectl delete -f 02-hello-ingress.yaml
kubectl delete -f 01-hello-app.yaml
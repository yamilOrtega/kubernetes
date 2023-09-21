kubectl apply -f 01-hello-app.yaml
kubectl delete -f 02-hello-ingress.yaml
kubectl apply -f 03-issuer.yaml
kubectl apply -f 03.1-Certificate.yaml
kubectl apply -f 04-hello-ingress-tls.yaml 
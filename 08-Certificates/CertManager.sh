kubectl create ns cert-manager
kubectl apply --validate=false -f cert-manager.yaml
#Info https://cert-manager.io/docs/installation/kubectl/
#kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml
#kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/vX.Y.Z/cert-manager.yaml
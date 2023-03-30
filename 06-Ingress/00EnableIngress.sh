helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

helm search repo ingress

kubectl create ns ingress-nginx
helm install nginx-ingress ingress-nginx/ingress-nginx -n ingress-nginx --values 00ingress_configuration.yaml 
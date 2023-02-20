curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx


helm repo update
helm repo list

helm upgrade --install my-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace --values values.yml


kubectl apply -f 05Ingress.yaml




kubectl get services nginx-ingress-nginx-ingress
kubectl get services nginx-ingress-nginx-ingress
helm repo update
helm install nginx-ingress nginx-stable/nginx-ingress --set rbac.create=true

kubectl get pods --all-namespaces -l app=nginx-ingress-nginx-ingress
kubectl get services nginx-ingress-nginx-ingres
#Create ACR on azure container registry
#docker login -u kubernetescongresofoss -p nD7cPWzfq9knoAnelM+nA4PvY+E239Xm8U1QhKaCwd+ACRAfhtGO congresofosscr.azurecr.io
#nD7cPWzfq9knoAnelM+nA4PvY+E239Xm8U1QhKaCwd+ACRAfhtGO

kubectl create secret docker-registry acr-auth \
    --docker-server=congresofosscr.azurecr.io \
    --docker-username=kubernetescongresofoss \
    --docker-password=nD7cPWzfq9knoAnelM+nA4PvY+E239Xm8U1QhKaCwd+ACRAfhtGO
#Se agrega al service acount default la descarga del secret 
kubectl patch serviceaccount default \
  -p '{"imagePullSecrets": [{"name": "acr-auth"}]}'

      #--docker-email=<your-acr-email>
#kubectl apply -f 01-congresofoss-app.yaml
    

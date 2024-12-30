### Create generic secret
kubectl create secret generic asp-template-secret \
  --from-literal=apiKey=your-api-key-value \
  --from-literal=databaseUrl=your-database-url \
  --namespace=your-namespace \
  --dry-run=client -o yaml | kubectl apply -f -

### Create tls secret
kubectl create secret tls tls-secret-name \
  --cert="path/to/your-cert.pem" \
  --key="path/to/your-key.pem" \
  --namespace=your-namespace \
  --dry-run=client -o yaml | kubectl apply -f -


### Create tls secret from value
kubectl create secret tls tls-secret-name \
  --cert=<(echo "-----BEGIN CERTIFICATE-----
<your-certificate-content>
-----END CERTIFICATE-----") \
  --key=<(echo "-----BEGIN PRIVATE KEY-----
<your-private-key-content>
-----END PRIVATE KEY-----") \
--namespace=your-namespace \
--dry-run=client -o yaml | kubectl apply -f -


#### Create registtry credential
kubectl create secret docker-registry <name> \ 
--docker-server=<your-registry-server> \
--docker-username=<your-name> \ 
--docker-password=<your-pword> \ 
--namespace=your-namespace \
--dry-run=client -o yaml | kubectl apply -f -

### Configure RBAC ArgoCD
kubectl edit configmap argocd-rbac-cm -n argocd
########################################
data:
  policy.csv: |
    p, role:full-access, *, *, *, allow
    p, role:sync-restart, applications, sync, *, allow
    
    p, role:sync-restart, applications, action/restart, *, allow
    
    g, webhook, role:full-access
    
    g, webhook, role:sync-restart
########################################

##### Add user to AgrgoCD
kubectl edit configmap argocd-cm -n argocd 
########################################
data:
  accounts.webhook: apiKey
########################################

### Switch context ###
kubectl config set-context --current --namespace=asp-template 

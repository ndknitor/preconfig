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

### Backup namespaces ###
kubectl get all --all-namespaces -o yaml > k8s-namespaces.yaml

### Backup ConfigMaps, Secrets, or Custom Resources (CRDs) ###
kubectl get configmaps --all-namespaces -o yaml > configmaps.yaml
kubectl get secrets --all-namespaces -o yaml > secrets.yaml
kubectl get crds -o yaml > crds.yaml

### Backup PV, PVC ###
kubectl get pv -o yaml > pvs.yaml
kubectl get pvc --all-namespaces -o yaml > pvcs.yaml

### Backup Cluster Roles and Role Bindings ###
kubectl get clusterroles -o yaml > clusterroles.yaml
kubectl get clusterrolebindings -o yaml > clusterrolebindings.yaml
kubectl get roles --all-namespaces -o yaml > roles.yaml
kubectl get rolebindings --all-namespaces -o yaml > rolebindings.yaml


### Backup ingress service and network policy
kubectl get ingress --all-namespaces -o yaml > ingress.yaml
kubectl get services --all-namespaces -o yaml > services.yaml
kubectl get networkpolicies --all-namespaces -o yaml > networkpolicies.yaml

#Backup everything
kubectl get $(kubectl api-resources --verbs=list -o name | tr '\n' ',' | sed 's/,$//') --all-namespaces -o yaml > full-k8s-backup.yaml

#Backup PVC data
export RESTIC_REPOSITORY="s3:http://minio.example.com/k8s-backups"
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
#Init backup
restic init
#backup
restic backup /mnt/pvc-data

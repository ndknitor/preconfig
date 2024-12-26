#### Login to registtry
kubectl create secret docker-registry <name> --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword>

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

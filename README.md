# TODO
> On peut déployer External Secrets Operator pour faire le pont entre Vault et  ?

# Introduction
Tester quelques fonctionnalités :
- Creer des secrets avec Vault
- Utiliser Terraform pour creer les secrets
- Injecter les secrets dans les variables d'environnements lors du deploiement

# Docker
```
cd .\src\POC.ShowEnvironmentVariables\POC.ShowEnvironmentVariables
docker build -t showenvs:latest .
docker tag showenvs:latest sadrifertani/showenvs:latest
docker push sadrifertani/showenvs:latest
```

# Helm
```
helm lint ./helm/POC.ShowEnvironmentVariables
helm install show-vars-env ./helm/POC.ShowEnvironmentVariables -n poc-space

kubectl delete job showenvs-job -n poc-space
helm upgrade show-vars-env ./helm/POC.ShowEnvironmentVariables -n poc-space
```

# Vault-K8S
## Activer l’authentification Kubernetes dans Vault
```
vault auth enable kubernetes
```
## Créer un rôle Vault lié à Kubernetes
```
vault write auth/kubernetes/role/mon-role-k8s bound_service_account_names=default bound_service_account_namespaces=poc-space policies=mon-db-policy ttl=24h audience="vault"
```

## Créer la policy
```
vault policy write mon-db-policy mon-db-policy.hcl
```

##
```
kubectl delete job showenvs-job -n poc-space
helm upgrade --install show-vars-env ./helm/POC.ShowEnvironmentVariables -n poc-space
```

```
kubectl exec -it vault-0 -n vault -- /bin/sh
$ echo $KUBERNETES_PORT_443_TCP_ADDR
10.43.0.1
```

```
kubectl exec -it vault-0 -n vault -- /bin/sh
/ $ vault write auth/kubernetes/config token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" kubernetes_host="https://10.43.0.1" kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
Success! Data written to: auth/kubernetes/config
```

# Traces
```
kubectl get pods -n poc-space
NAME                                        READY   STATUS     RESTARTS       AGE
kafkaconsumer-deployment-59c487f799-xjv2q   2/2     Running    4 (166m ago)   24h
kafkaproducer-deployment-55b55d6664-ws2h4   2/2     Running    4 (166m ago)   24h
showenvs-job-9x5st                          2/3     NotReady   0              42s
```

```
kubectl logs showenvs-job-9x5st -n poc-space
Variables d'environnement :
HOSTNAME = showenvs-job-9x5st
KAFKAPRODUCER_SERVICE_PORT_80_TCP_PROTO = tcp
ASPNETCORE_HTTP_PORTS = 8080
DB_USER = admin
SHOWENVS_SERVICE_SERVICE_PORT = 80
_ = /usr/bin/dotnet
PWD = /app
KAFKAPRODUCER_SERVICE_SERVICE_HOST = 10.43.207.196
ASPNETCORE_ENVIRONMENT = Production
APP_UID = 1654
DB_PASS = motdepasse123
KAFKACONSUMER_SERVICE_PORT_80_TCP_ADDR = 10.43.128.86
KUBERNETES_PORT = tcp://10.43.0.1:443
KAFKACONSUMER_SERVICE_PORT_80_TCP_PORT = 80
SHLVL = 0
KUBERNETES_SERVICE_HOST = 10.43.0.1
SHOWENVS_SERVICE_SERVICE_HOST = 10.43.116.184
KUBERNETES_SERVICE_PORT = 443
DOTNET_VERSION = 8.0.19
KAFKACONSUMER_SERVICE_SERVICE_PORT = 80
SHOWENVS_SERVICE_PORT_80_TCP = tcp://10.43.116.184:80
KAFKACONSUMER_SERVICE_SERVICE_HOST = 10.43.128.86
KAFKACONSUMER_SERVICE_PORT = tcp://10.43.128.86:80
KUBERNETES_PORT_443_TCP_PORT = 443
SHOWENVS_SERVICE_PORT_80_TCP_ADDR = 10.43.116.184
KAFKAPRODUCER_SERVICE_PORT_80_TCP_PORT = 80
KAFKAPRODUCER_SERVICE_PORT = tcp://10.43.207.196:80
DOTNET_RUNNING_IN_CONTAINER = true
KAFKACONSUMER_SERVICE_PORT_80_TCP = tcp://10.43.128.86:80
KAFKACONSUMER_SERVICE_PORT_80_TCP_PROTO = tcp
KUBERNETES_PORT_443_TCP = tcp://10.43.0.1:443
SHOWENVS_SERVICE_PORT_80_TCP_PROTO = tcp
HOME = /home/app
KUBERNETES_SERVICE_PORT_HTTPS = 443
SHOWENVS_SERVICE_PORT_80_TCP_PORT = 80
KAFKAPRODUCER_SERVICE_PORT_80_TCP_ADDR = 10.43.207.196
KAFKAPRODUCER_SERVICE_PORT_80_TCP = tcp://10.43.207.196:80
PATH = /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
SHOWENVS_SERVICE_PORT = tcp://10.43.116.184:80
KUBERNETES_PORT_443_TCP_ADDR = 10.43.0.1
KUBERNETES_PORT_443_TCP_PROTO = tcp
KAFKAPRODUCER_SERVICE_SERVICE_PORT = 80
Fin.
```

kubectl logs showenvs-job-nsdpm -n poc-space -c vault-agent

## VSO : Vault Secrets Operator
```
kubectl apply -f vaultstaticsecret.yaml -n poc-space
```

```
 kubectl get secret mon-secret -n poc-space -o yaml
apiVersion: v1
data:
  app_pass: cGFzczAx
  app_user: dXNlcjAx
kind: Secret
metadata:
  creationTimestamp: "2025-09-11T16:17:10Z"
  name: mon-secret
  namespace: poc-space
  resourceVersion: "333453"
  uid: 9250227c-2bd1-4870-b9d5-be9680e37c0e
type: Opaque
```

## Update secret Vault
```
terraform init
terraform plan
terraform apply
```


```
$ts = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
kubectl annotate vaultstaticsecret mon-secret `-n poc-space ` vso.hashicorp.com/force-sync="$ts" ` --overwrite

```
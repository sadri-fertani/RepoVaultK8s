# Introduction
Pour utiliser vault-k8s sur le poste Host, il faut faire un forward du port 8200 en http pour service vault.
> Vault étant installé en mode dev, donc la sécurité TLS n'est pas activé (pas de https)
```
kubectl port-forward svc/vault 8200:8200 -n vault
```

Puis, il faut créer une variable d'environnement sur le Host
```
export VAULT_ADDR='http://127.0.0.1:8200'
```

Test
```
curl http://127.0.0.1:8200/v1/sys/health
```

Login
> defualt mdp : root
```
vault login
```

Activer le moteur des secrets KV si necessaire (version dev : deja activer)
```
vault secrets list
vault secrets enable -path=secret kv
```

# Creation d'un secret

## Vault Cli
```
vault kv put secret/mon-secret-01 username="sadri" password="supersecret"

vault kv get secret/mon-secret-01
```

## Terraform
Voir fichiers dans ce repertoire : 
- provider.tf
- variables.tf
- secrets.tf
- main.tf

```
terraform init
terraform apply -var="vault_token=root"
```

```
vault kv get secret/data/mon-app
vault kv get secret/data/mon-db
```

### Vault output secrets
```
====== Secret Path ======
secret/data/mon-secret-01

======= Metadata =======
Key                Value
---                -----
created_time       2025-09-10T13:41:50.304199977Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            1

====== Data ======
Key         Value
---         -----
password    supersecret
username    sadri


====== Secret Path ======
secret/data/data/mon-app

======= Metadata =======
Key                Value
---                -----
created_time       2025-09-10T15:29:38.113599015Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            1

==== Data ====
Key     Value
---     -----
data    map[password:supersecretinconnu username:sadri]


===== Secret Path =====
secret/data/data/mon-db

======= Metadata =======
Key                Value
---                -----
created_time       2025-09-10T15:29:38.19805179Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            1

==== Data ====
Key     Value
---     -----
data    map[db_pass:motdepasse123 db_user:admin]
```
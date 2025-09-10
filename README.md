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
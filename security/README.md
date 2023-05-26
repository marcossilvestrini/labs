# PLEASE: NOT EXPOSE THIS FILES NEVER.

## file: id_ecdsa.pub

Your pub key for ssh access

## file: .aws-secrets

***IT'S RECOMENDED THAT YOU USE ENVIRONMENT VARIABLES FOR SECRETS***

```json
{  
    "terraform_access_key": "YOUR_ACCESS_KEY",
    "terraform_secret_key": "YOUR_SECRET_KEY"
}

```

## file .docker-secrets

***IT'S RECOMENDED THAT YOU USE ENVIRONMENT VARIABLES FOR SECRETS***

```json
{
    "username": "YOUR_DOCKERHUB_USERNAME",
    "password": "YOUR_DOCKERHUB_PASSWORD"
}
```

```json
{  
  "username": "YOUR_AZURE_PORTAL_USERNAME",
  "password": "YOUR_AZURE_PORTAL_PASSWORD_CRYPTED",
  "clientId": "YOUR_PRINCIPAL_SERVICE_CLIENT_ID",
  "clientSecret": "YOUR_PRINCIPAL_SERVICE_CLIENT_SECRET",
  "subscriptionId": "YOOUR_SUBSCRIPTION_ID",
  "tenantId": "YOUR_PRINCIPAL_SERVICE_TENANT_ID",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
```

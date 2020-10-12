# Modify for your environment.
# ACR_NAME: The name of your Azure Container Registry
# SERVICE_PRINCIPAL_NAME: Must be unique within your AD tenant
# tsacrpoc.azurecr.io
$ACR_NAME = "tsacrpoc"
$SERVICE_PRINCIPAL_NAME = "acr-service-principal"

# Obtain the full registry ID for subsequent command args
$ACR_REGISTRY_ID = $(az acr show --name $ACR_NAME --query id --output tsv)

# Existing SP in FMG:
# ID:  53f6e507-7f68-4eed-be56-ac3f3d577d3f
# Password: b8238fb5-b57d-48eb-83e9-39376d929347

# Create the service principal with rights scoped to the registry.
# Default permissions are for docker pull access. Modify the '--role'
# argument value as desired:
# acrpull:     pull only
# acrpush:     push and pull
# owner:       push, pull, and assign roles


$SP_PASSWD = $(az ad sp create-for-rbac --name http://$SERVICE_PRINCIPAL_NAME --scopes $ACR_REGISTRY_ID --role acrpull --query password --output tsv)
$SP_APP_ID = $(az ad sp show --id http://$SERVICE_PRINCIPAL_NAME --query appId --output tsv)

# Output the service principal's credentials; use these in your services and
# applications to authenticate to the container registry.
Write-Host "Service principal ID: $SP_APP_ID"
Write-Host "Service principal password: $SP_PASSWD"

kubectl create secret docker-registry acr-secret `
    --docker-server="$ACR_NAME.azurecr.io" `
    --docker-username=$SP_APP_ID `
    --docker-password=$SP_PASSWD
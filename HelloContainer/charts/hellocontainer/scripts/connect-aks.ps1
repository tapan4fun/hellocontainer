$rg = "ts-aks-dev"
$aksName = "tsaksdevcluster"

az aks get-credentials --resource-group $rg --name $aksName
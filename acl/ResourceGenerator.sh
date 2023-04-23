# Resources Name
subscription_id=$(az account show --query id -o tsv)
resource_group_name="DGB-RG-PF-001"
resource_group_name_dl_dev="DGB-RG-DL-DEV-001"
resource_group_name_dl_test="DGB-RG-DL-TEST-001"
resource_group_name_dl_prod="DGB-RG-DL-PROD-001"
storage_account_name="dgbstpf001"
key_vault_name="DGB-KV-PF-001"

#Service Principal information
service_principal_dev_name="DGB-SP-PF-DEV-001"
service_principal_test_name="DGB-SP-PF-TEST-001"
service_principal_prod_name="DGB-SP-PF-PROD-001"
service_principal_secret_dev="DBGPFSPDEVSER001"
service_principal_secret_test="DBGPFSPTESTSER001"
service_principal_secret_prod="DBGPFSPPRODSER001"

# Resource Parameters
location="centralindia"
storage_sku="Standard_LRS"
storage_kind="StorageV2"
sp_role="Contributor"
dev_container_name="tfdev"
test_container_name="tftest"
prod_container_name="tfprod"

# Set Subscription
az account set --subscription=${subscription_id}

# ------------------------------------------------------------------------------------------------------
# Create resource group for Platform, Dev, Test, Prod
# ------------------------------------------------------------------------------------------------------

# Create Platform Resource Group
az group create -l ${location} -n ${resource_group_name}

# Create Data lake Dev Resource Group
az group create -l ${location} -n ${resource_group_name_dl_dev}

# Create Data lake Test Resource Group
az group create -l ${location} -n ${resource_group_name_dl_test}

# Create Data lake Prod Resource Group
az group create -l ${location} -n ${resource_group_name_dl_prod}

# ------------------------------------------------------------------------------------------------------
# Create ADLS Gen2 Storage and respective container for Platform
# ------------------------------------------------------------------------------------------------------

# Create ADLS Gen 2 storage account
az storage account create --name ${storage_account_name} \
    --resource-group ${resource_group_name} \
    --location ${location} \
    --sku ${storage_sku} \
    --kind ${storage_kind} --hierarchical-namespace true

# Create Dev container inside storage account
az storage container create -n ${dev_container_name} --account-name ${storage_account_name} --auth-mode login

# Create Test container inside storage account
az storage container create -n ${test_container_name} --account-name ${storage_account_name} --auth-mode login

# Create Prod container inside storage account
az storage container create -n ${prod_container_name} --account-name ${storage_account_name} --auth-mode login

# ------------------------------------------------------------------------------------------------------
# Create Key Vault for Platform
# ------------------------------------------------------------------------------------------------------

# Create Key Vault
az keyvault create --name ${key_vault_name} --resource-group ${resource_group_name} --location ${location}


# ------------------------------------------------------------------------------------------------------
# Service Principal for Dev Environment
# ------------------------------------------------------------------------------------------------------

# Create Dev Service Principal
SP_DEV_CLIENT_SECRET=$(MSYS_NO_PATHCONV=1 az ad sp create-for-rbac --name ${service_principal_dev_name} \
                         --role ${sp_role} \
                         --scopes /subscriptions/${subscription_id}/resourceGroups/${resource_group_name}/providers/Microsoft.Storage/storageAccounts/${storage_account_name}/blobServices/default/containers/${dev_container_name} /subscriptions/${subscription_id}/resourceGroups/${resource_group_name_dl_dev} \
                         --query password \
                         --output tsv)

echo "Service Principal ${service_principal_dev_name} password is ${SP_DEV_CLIENT_SECRET}"

# Set Service principal password into key vault
az keyvault secret set --vault-name ${key_vault_name} --name ${service_principal_secret_dev} --value ${SP_DEV_CLIENT_SECRET}


# ------------------------------------------------------------------------------------------------------
# Service Principal for test Environment
# ------------------------------------------------------------------------------------------------------

# Create Test Service Principal
SP_TEST_CLIENT_SECRET=$(MSYS_NO_PATHCONV=1 az ad sp create-for-rbac --name ${service_principal_test_name} \
                         --role ${sp_role} \
                         --scopes /subscriptions/${subscription_id}/resourceGroups/${resource_group_name}/providers/Microsoft.Storage/storageAccounts/${storage_account_name}/blobServices/default/containers/${test_container_name} /subscriptions/${subscription_id}/resourceGroups/${resource_group_name_dl_test} \
                         --query password \
                         --output tsv)

echo "Service Principal ${service_principal_dev_name} password is ${SP_TEST_CLIENT_SECRET}"

# Set Service principal password into key vault
az keyvault secret set --vault-name ${key_vault_name} --name ${service_principal_secret_test} --value ${SP_TEST_CLIENT_SECRET}

# ------------------------------------------------------------------------------------------------------
# Service Principal for test Environment
# ------------------------------------------------------------------------------------------------------

# Create Dev Service Principal
SP_PROD_CLIENT_SECRET=$(MSYS_NO_PATHCONV=1 az ad sp create-for-rbac --name ${service_principal_prod_name} \
                         --role ${sp_role} \
                         --scopes /subscriptions/${subscription_id}/resourceGroups/${resource_group_name}/providers/Microsoft.Storage/storageAccounts/${storage_account_name}/blobServices/default/containers/${prod_container_name} /subscriptions/${subscription_id}/resourceGroups/${resource_group_name_dl_prod} \
                         --query password \
                         --output tsv)

echo "Service Principal ${service_principal_dev_name} password is ${SP_PROD_CLIENT_SECRET}"

# Set Service principal password into key vault
az keyvault secret set --vault-name ${key_vault_name} --name ${service_principal_secret_prod} --value ${SP_PROD_CLIENT_SECRET}

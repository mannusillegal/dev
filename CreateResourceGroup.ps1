##########################################################################################################
<#
.SYNOPSIS
    Create resource group, storage account and storage contanier for the logic app deployment
    
.DESCRIPTION
    This script will create the following components
    -	Resource group:  storage account ,storage container and other resources required for the Deployment
    -   you can edit on deploymentPrefix, deploymentnumber.

   

#>
##########################################################################################################

# Connect to Azure

Login-AzurermAccount

# Select Azure Subscription
$sub = Get-AzureRMsubscription
Select-AzureRmSubscription -SubscriptionId $sub[0].SubscriptionId

# Set values for new resource group, storage account 
$deploymentPrefix = "test123"
$deploymentnumber = "deploy1"
$rgName = $deploymentPrefix + $deploymentnumber #New resource group name
$locName = "central us" # Loation of new resource group, we can choose any location for the deployment e.g. West US, central us etc.
$saName = $rgName.Replace("-","").tolower() # Storage account name (for new resource group)
$saType="Standard_LRS" # Storage account type


#To make output in green colour
 
 function Receive-Output 
{
    process { Write-Host $_ -ForegroundColor Green }
}

## Create initial resources
# create resource group
New-AzureRmResourceGroup -Name $rgName -Location $locName | Out-Null
write-output "1/14 - the resource group has been created successfully" | Receive-Output

# create storage account
New-AzureRmStorageAccount -Name $saName -ResourceGroupName $rgName –Type $saType -Location $locName | Out-Null
write-output "2/14 - the storage account has been created successfully" | Receive-Output

# get storage account key
$key1 = (Get-AzureRmStorageAccountKey -Name $saName -ResourceGroupName $rgName).Value[0]

# create storage context
$storagecontext = New-AzureStorageContext -StorageAccountName $saname -StorageAccountKey $key1

# create a container called scripts
#New-AzureStorageContainer -Name "source" -Context $storagecontext -Permission BLOB  | Out-Null
#write-output "3/14 - Scripts Container has been created successfully"| Receive-Output

New-AzureStorageContainer -Name "doc" -Context $storagecontext -Permission BLOB | Out-Null
write-output "4/14 - DOCS Container has been created successfully" | Receive-Output
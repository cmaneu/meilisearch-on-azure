// App Service - Bicep module
// Generated by NubesGen (www.nubesgen.com)
@description('The name of your application')
param applicationName string

@description('The environment (dev, test, prod, ...')
@maxLength(4)
param environment string = 'dev'

@description('The number of this specific instance')
@maxLength(3)
param instanceNumber string = '001'

@description('The Azure region where all resources in this example should be created')
param location string

@description('An array of NameValues that needs to be added as environment variables')
param environmentVariables array

@description('A list of tags to apply to the resources')
param resourceTags object

param shareStorageName string
param shareName string
param shareMountPath string


var appServicePlanName = 'plan-${applicationName}-${instanceNumber}'
var meilisearchImageName = 'getmeili/meilisearch:latest'

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name: shareStorageName
}

resource appServicePlan 'Microsoft.Web/serverFarms@2020-12-01' = {
  name: appServicePlanName
  location: location
  tags: resourceTags
  kind: 'linux'
  properties: {
    reserved: true
  }
  sku: {
    tier: 'Standard'
    name: 'S1'
  }
}

// Reference: https://docs.microsoft.com/azure/templates/microsoft.web/sites?tabs=bicep
resource appServiceApp 'Microsoft.Web/sites@2020-12-01' = {
  name: 'app-${applicationName}-${environment}-${instanceNumber}'
  location: location
  tags: resourceTags
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    clientAffinityEnabled: false
    siteConfig: {
      azureStorageAccounts: {
        
      }
      linuxFxVersion: 'DOCKER|${meilisearchImageName}'
      alwaysOn: false
      ftpsState: 'FtpsOnly'
      http20Enabled: true
      minTlsVersion: '1.2'
      appSettings: union(environmentVariables, [
        { 
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: false
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://index.docker.io'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: ''
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: ''
        }
        {
          name: 'WEBSITES_PORT'
          value: '7700'
        }
        ])
      }
    }
    
}

resource storageSetting 'Microsoft.Web/sites/config@2021-01-15' = if(!empty(shareName)) {
  name: '${appServiceApp.name}/azurestorageaccounts'
  properties: {
    'meilidb': {
      type: 'AzureFiles'
      shareName: shareName
      mountPath: shareMountPath
      accountName: shareStorageName
      accessKey: listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value
    }
  }
}

output application_hostname string = appServiceApp.properties.hostNames[0]

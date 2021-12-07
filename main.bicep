targetScope = 'subscription'

@description('The name of environment (dev, prod, ...)')
param environment string = 'dev'
@description('The name of your search service. This value should be unique')
param applicationName string = 'meilisearch'
@description('The Azure region code.')
param location string = 'eastus'
@secure()
@description('The API Key used to connect to your Meilisearch instance.')
param meilisearch_apikey string = newGuid()

var instanceNumber = '001'
var shareName = 'meilisearch'

var defaultTags = {
  'environment': environment
  'application': applicationName
}

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${applicationName}-${instanceNumber}'
  location: location
  tags: defaultTags
}

module storage 'modules/storage/storage.bicep' = {
  name: 'storage'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    applicationName: applicationName
    environment: environment
    resourceTags: defaultTags
    instanceNumber: instanceNumber
  }
}

module fileShare 'modules/storage/file-share.bicep'= {
  name: 'fileShare'
  scope: resourceGroup(rg.name)
  params: {
    parentStorageAccountName: storage.outputs.storageAccountName
    shareName: shareName
  }
}

module webApp 'modules/app-service/app-service.bicep' = {
  name: 'webApp'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    applicationName: applicationName
    environment: environment
    resourceTags: defaultTags
    instanceNumber: instanceNumber
    shareName: shareName
    shareStorageName: storage.outputs.storageAccountName
    shareMountPath: '/data/meili'
    environmentVariables: [ 
      { 
        name: 'MEILI_MASTER_KEY'
        value: meilisearch_apikey
      }
      { 
        name: 'MEILI_DB_PATH'
        value: '/data/meili'
      }
    ]
  }
}

output MeilisearchApiUrl string = webApp.outputs.application_hostname
output MeilisearchResourceGroup string = rg.name

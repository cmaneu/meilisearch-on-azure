
param parentStorageAccountName string
param shareName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name: parentStorageAccountName
}

resource storageShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-06-01' = {
  name: '${storageAccount.name}/default/${shareName}'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 5120
    enabledProtocols: 'SMB'
  }
}

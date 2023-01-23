targetScope = 'subscription'

// If an environment is set up (dev, test, prod...), it is used in the application name
param environment string = 'dev'
param applicationName string = 'monsitegemina'
param location string = 'francecentral'

param searchServices_emdelsearch_name string = 'Geminasearch'
param storageAccounts_emdelstorage_name string = 'Geminastorage'
param accounts_emdeltransalor_name string = 'geminatransalor'
param databaseAccounts_demoedeletang_name string = 'Geminadeletang'
param databaseAccounts_edeletangdemograph_name string = 'Geminademograph'
param databaseAccounts_demomongoapiedeletang_name string = 'Geminamongoapiedeletang'


var instanceNumber = '001'

var defaultTags = {
  'environment': environment
  'application': applicationName
  'nubesgen-version': '0.8.1'
}

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${applicationName}-${environment}-${instanceNumber}'
  location: location
  tags: defaultTags
}


resource accounts_emdeltransalor_name_resource 'Microsoft.CognitiveServices/accounts@2022-10-01' = {
  name: accounts_emdeltransalor_name
  location: location
  sku: {
    name: 'F0'
  }
  kind: 'TextTranslation'
  identity: {
    type: 'None'
  }
  properties: {
    customSubDomainName: accounts_emdeltransalor_name
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource databaseAccounts_demoedeletang_name_resource 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
  name: databaseAccounts_demoedeletang_name
  location: location
  tags: {
    defaultExperience: 'Core (SQL)'
    'hidden-cosmos-mmspecial': ''
  }
  kind: 'GlobalDocumentDB'
  identity: {
    type: 'None'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
    isVirtualNetworkFilterEnabled: false
    virtualNetworkRules: []
    disableKeyBasedMetadataWriteAccess: false
    enableFreeTier: false
    enableAnalyticalStorage: true
    analyticalStorageConfiguration: {
      schemaType: 'WellDefined'
    }
    databaseAccountOfferType: 'Standard'
    defaultIdentity: 'FirstPartyIdentity'
    networkAclBypass: 'None'
    disableLocalAuth: false
    enablePartitionMerge: false
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
      maxIntervalInSeconds: 5
      maxStalenessPrefix: 100
    }
    locations: [
      {
        locationName: location
        provisioningState: 'Succeeded'
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    cors: []
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
    ipRules: []
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
        backupIntervalInMinutes: 240
        backupRetentionIntervalInHours: 8
        backupStorageRedundancy: 'Geo'
      }
    }
    networkAclBypassResourceIds: []
    keysMetadata: {
    }
  }
}

resource databaseAccounts_demomongoapiedeletang_name_resource 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
  name: databaseAccounts_demomongoapiedeletang_name
  location: location
  tags: {
    defaultExperience: 'Azure Cosmos DB for MongoDB API'
    'hidden-cosmos-mmspecial': ''
  }
  kind: 'MongoDB'
  identity: {
    type: 'None'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
    isVirtualNetworkFilterEnabled: false
    virtualNetworkRules: []
    disableKeyBasedMetadataWriteAccess: false
    enableFreeTier: false
    enableAnalyticalStorage: true
    analyticalStorageConfiguration: {
      schemaType: 'FullFidelity'
    }
    databaseAccountOfferType: 'Standard'
    defaultIdentity: 'FirstPartyIdentity'
    networkAclBypass: 'None'
    disableLocalAuth: false
    enablePartitionMerge: false
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
      maxIntervalInSeconds: 5
      maxStalenessPrefix: 100
    }
    apiProperties: {
      serverVersion: '4.2'
    }
    locations: [
      {
         location: location
        provisioningState: 'Succeeded'
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    cors: []
    capabilities: [
      {
        name: 'EnableMongo'
      }
      {
        name: 'DisableRateLimitingResponses'
      }
      {
        name: 'EnableServerless'
      }
      {
        name: 'EnableMongoRoleBasedAccessControl'
      }
    ]
    ipRules: []
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
        backupIntervalInMinutes: 240
        backupRetentionIntervalInHours: 8
        backupStorageRedundancy: 'Geo'
      }
    }
    networkAclBypassResourceIds: []
    keysMetadata: {
    }
  }
}

resource databaseAccounts_edeletangdemograph_name_resource 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
  name: databaseAccounts_edeletangdemograph_name
  location: location
  tags: {
    defaultExperience: 'Gremlin (graph)'
    'hidden-cosmos-mmspecial': ''
  }
  kind: 'GlobalDocumentDB'
  identity: {
    type: 'None'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
    isVirtualNetworkFilterEnabled: false
    virtualNetworkRules: []
    disableKeyBasedMetadataWriteAccess: false
    enableFreeTier: false
    enableAnalyticalStorage: true
    analyticalStorageConfiguration: {
      schemaType: 'WellDefined'
    }
    databaseAccountOfferType: 'Standard'
    defaultIdentity: 'FirstPartyIdentity'
    networkAclBypass: 'None'
    disableLocalAuth: false
    enablePartitionMerge: false
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
      maxIntervalInSeconds: 5
      maxStalenessPrefix: 100
    }
    locations: [
      {
         location: location
        provisioningState: 'Succeeded'
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    cors: []
    capabilities: [
      {
        name: 'EnableGremlin'
      }
    ]
    ipRules: []
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
        backupIntervalInMinutes: 240
        backupRetentionIntervalInHours: 8
        backupStorageRedundancy: 'Geo'
      }
    }
    networkAclBypassResourceIds: []
    keysMetadata: {
    }
  }
}

resource searchServices_emdelsearch_name_resource 'Microsoft.Search/searchServices@2021-04-01-preview' = {
  name: searchServices_emdelsearch_name
 location: location
  sku: {
    name: 'basic'
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
    hostingMode: 'default'
    publicNetworkAccess: 'Enabled'
    networkRuleSet: {
      ipRules: []
      bypass: 'None'
    }
    encryptionWithCmk: {
      enforcement: 'Unspecified'
    }
    disableLocalAuth: false
    authOptions: {
      apiKeyOnly: {
      }
    }
    disabledDataExfiltrationOptions: []
    semanticSearch: 'disabled'
  }
}

resource storageAccounts_emdelstorage_name_resource 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccounts_emdelstorage_name
   location: location
  sku: {
    name: 'Standard_RAGRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    defaultToOAuthAuthentication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    isHnsEnabled: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource databaseAccounts_edeletangdemograph_name_gemina 'Microsoft.DocumentDB/databaseAccounts/gremlinDatabases@2022-08-15' = {
  parent: databaseAccounts_edeletangdemograph_name_resource
  name: 'gemina'
  properties: {
    resource: {
      id: 'gemina'
    }
  }
}

resource databaseAccounts_edeletangdemograph_name_graphdb 'Microsoft.DocumentDB/databaseAccounts/gremlinDatabases@2022-08-15' = {
  parent: databaseAccounts_edeletangdemograph_name_resource
  name: 'graphdb'
  properties: {
    resource: {
      id: 'graphdb'
    }
  }
}

resource databaseAccounts_demomongoapiedeletang_name_restaurant 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2022-08-15' = {
  parent: databaseAccounts_demomongoapiedeletang_name_resource
  name: 'restaurant'
  properties: {
    resource: {
      id: 'restaurant'
    }
  }
}


resource databaseAccounts_demoedeletang_name_gemina 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-08-15' = {
  parent: databaseAccounts_demoedeletang_name_resource
  name: 'gemina'
  properties: {
    resource: {
      id: 'gemina'
    }
  }
}


resource databaseAccounts_demoedeletang_name_00000000_0000_0000_0000_000000000001 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2022-08-15' = {
  parent: databaseAccounts_demoedeletang_name_resource
  name: '00000000-0000-0000-0000-000000000001'
  properties: {
    roleName: 'Cosmos DB Built-in Data Reader'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_demoedeletang_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/executeQuery'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/readChangeFeed'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/read'
        ]
        notDataActions: []
      }
    ]
  }
}

resource databaseAccounts_edeletangdemograph_name_00000000_0000_0000_0000_000000000001 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2022-08-15' = {
  parent: databaseAccounts_edeletangdemograph_name_resource
  name: '00000000-0000-0000-0000-000000000001'
  properties: {
    roleName: 'Cosmos DB Built-in Data Reader'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_edeletangdemograph_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/executeQuery'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/readChangeFeed'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/read'
        ]
        notDataActions: []
      }
    ]
  }
}

resource databaseAccounts_demoedeletang_name_00000000_0000_0000_0000_000000000002 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2022-08-15' = {
  parent: databaseAccounts_demoedeletang_name_resource
  name: '00000000-0000-0000-0000-000000000002'
  properties: {
    roleName: 'Cosmos DB Built-in Data Contributor'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_demoedeletang_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
        ]
        notDataActions: []
      }
    ]
  }
}

resource databaseAccounts_edeletangdemograph_name_00000000_0000_0000_0000_000000000002 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2022-08-15' = {
  parent: databaseAccounts_edeletangdemograph_name_resource
  name: '00000000-0000-0000-0000-000000000002'
  properties: {
    roleName: 'Cosmos DB Built-in Data Contributor'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_edeletangdemograph_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
        ]
        notDataActions: []
      }
    ]
  }
}

resource storageAccounts_emdelstorage_name_default 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  parent: storageAccounts_emdelstorage_name_resource
  name: 'default'
  sku: {
    name: 'Standard_RAGRS'
    tier: 'Standard'
  }
  properties: {
    cors: {
      corsRules: [
        {
          allowedOrigins: [
            'https://language.cognitive.azure.com'
          ]
          allowedMethods: [
            'DELETE'
            'GET'
            'POST'
            'OPTIONS'
            'PUT'
          ]
          maxAgeInSeconds: 500
          exposedHeaders: [
            '*'
          ]
          allowedHeaders: [
            '*'
          ]
        }
      ]
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_emdelstorage_name_default 'Microsoft.Storage/storageAccounts/fileServices@2022-05-01' = {
  parent: storageAccounts_emdelstorage_name_resource
  name: 'default'
  sku: {
    name: 'Standard_RAGRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {
      }
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_emdelstorage_name_default 'Microsoft.Storage/storageAccounts/queueServices@2022-05-01' = {
  parent: storageAccounts_emdelstorage_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_emdelstorage_name_default 'Microsoft.Storage/storageAccounts/tableServices@2022-05-01' = {
  parent: storageAccounts_emdelstorage_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}


resource databaseAccounts_edeletangdemograph_name_gemina_restaurant 'Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs@2022-08-15' = {
  parent: databaseAccounts_edeletangdemograph_name_gemina
  name: 'restaurant'
  properties: {
    resource: {
      id: 'restaurant'
      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      partitionKey: {
        paths: [
          '/part'
        ]
        kind: 'Hash'
      }
      uniqueKeyPolicy: {
        uniqueKeys: []
      }
      conflictResolutionPolicy: {
        mode: 'LastWriterWins'
        conflictResolutionPath: '/_ts'
      }
    }
  }
  dependsOn: [

    databaseAccounts_edeletangdemograph_name_resource
  ]
}

resource databaseAccounts_demomongoapiedeletang_name_restaurant_menu 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2022-08-15' = {
  parent: databaseAccounts_demomongoapiedeletang_name_restaurant
  name: 'menu'
  properties: {
    resource: {
      id: 'menu'
      shardKey: {
        '_id': 'Hash'
      }
      indexes: [
        {
          key: {
            keys: [
              '_id'
            ]
          }
        }
        {
          key: {
            keys: [
              '$**'
            ]
          }
        }
      ]
    }
  }
  dependsOn: [

    databaseAccounts_demomongoapiedeletang_name_resource
  ]
}

resource databaseAccounts_demomongoapiedeletang_name_restaurant_orders 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2022-08-15' = {
  parent: databaseAccounts_demomongoapiedeletang_name_restaurant
  name: 'orders'
  properties: {
    resource: {
      id: 'orders'
      indexes: [
        {
          key: {
            keys: [
              '_id'
            ]
          }
        }
      ]
    }
  }
  dependsOn: [

    databaseAccounts_demomongoapiedeletang_name_resource
  ]
}


resource databaseAccounts_demoedeletang_name_gemina_leases 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-08-15' = {
  parent: databaseAccounts_demoedeletang_name_gemina
  name: 'leases'
  properties: {
    resource: {
      id: 'leases'
      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      partitionKey: {
        paths: [
          '/_partitionKey'
        ]
        kind: 'Hash'
        version: 2
      }
      uniqueKeyPolicy: {
        uniqueKeys: []
      }
      conflictResolutionPolicy: {
        mode: 'LastWriterWins'
        conflictResolutionPath: '/_ts'
      }
      analyticalStorageTtl: -1
    }
  }
  dependsOn: [

    databaseAccounts_demoedeletang_name_resource
  ]
}


resource databaseAccounts_demoedeletang_name_gemina_user 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-08-15' = {
  parent: databaseAccounts_demoedeletang_name_gemina
  name: 'user'
  properties: {
    resource: {
      id: 'user'
      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      partitionKey: {
        paths: [
          '/email'
        ]
        kind: 'Hash'
      }
      uniqueKeyPolicy: {
        uniqueKeys: []
      }
      conflictResolutionPolicy: {
        mode: 'LastWriterWins'
        conflictResolutionPath: '/_ts'
      }
      analyticalStorageTtl: -1
    }
  }
  dependsOn: [

    databaseAccounts_demoedeletang_name_resource
  ]
}



resource storageAccounts_emdelstorage_name_default_destination 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  parent: storageAccounts_emdelstorage_name_default
  name: 'destination'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'Container'
  }
  dependsOn: [

    storageAccounts_emdelstorage_name_resource
  ]
}

resource storageAccounts_emdelstorage_name_default_emdelfile 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  parent: storageAccounts_emdelstorage_name_default
  name: 'emdelfile'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'Container'
  }
  dependsOn: [

    storageAccounts_emdelstorage_name_resource
  ]
}

resource storageAccounts_emdelstorage_name_default_source 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  parent: storageAccounts_emdelstorage_name_default
  name: 'source'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'Container'
  }
  dependsOn: [

    storageAccounts_emdelstorage_name_resource
  ]
}

resource databaseAccounts_edeletangdemograph_name_gemina_restaurant_default 'Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs/throughputSettings@2022-08-15' = {
  parent: databaseAccounts_edeletangdemograph_name_gemina_restaurant
  name: 'default'
  properties: {
    resource: {
      throughput: 400
    }
  }
  dependsOn: [

    databaseAccounts_edeletangdemograph_name_gemina
    databaseAccounts_edeletangdemograph_name_resource
  ]
}

resource databaseAccounts_edeletangdemograph_name_graphdb_recommandations_default 'Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs/throughputSettings@2022-08-15' = {
  parent: databaseAccounts_edeletangdemograph_name_graphdb_recommandations
  name: 'default'
  properties: {
    resource: {
      throughput: 400
    }
  }
  dependsOn: [

    databaseAccounts_edeletangdemograph_name_graphdb
    databaseAccounts_edeletangdemograph_name_resource
  ]
}
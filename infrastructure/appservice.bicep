param appName string
param acrName string
param acrResourceGroup string
param sku string = 'Free'
param containerImage string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appName
  location: resourceGroup().location
  sku: {
    name: sku
    capacity: 1
  }
}

resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: appName
  location: resourceGroup().location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        },
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: reference(acrName, '2021-07-01').loginServerUrl
        },
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: reference(acrName, '2021-07-01').adminUsername
        },
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: listKeys(acrResourceGroup, acrName, '2021-07-01').keys[0].value
        },
        {
          name: 'WEBSITES_PORT'
          value: '80'
        },
        {
          name: 'DOCKER_CUSTOM_IMAGE_NAME'
          value: containerImage
        }
      ]
    }
  }
  dependsOn: [
    appServicePlan
  ]
}

output endpoint string = appService.properties.defaultHostName

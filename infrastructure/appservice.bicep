param appName string
param acrName string
// param acrResourceGroup string
param sku string = 'F1'
param containerImage string
param location string = resourceGroup().location

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = { 
  name: acrName
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appName
  location: location
  sku: {
    name: sku
    capacity: 1
  }
}

resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: acr.properties.loginServer
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: acr.listCredentials().username // reference(acrName).adminUsername
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: acr.listCredentials().passwords[0].value //listKeys(acrResourceGroup, acrName).keys[0].value
        }
        {
          name: 'WEBSITES_PORT'
          value: '80'
        }
        {
          name: 'DOCKER_CUSTOM_IMAGE_NAME'
          value: containerImage
        }
      ]
    }
  }
}

output endpoint string = appService.properties.defaultHostName

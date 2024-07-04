metadata info = {
  title: 'Azure API Infra Module'
  description: 'Module for setting up the infrastructure for an API'
  version: '1.0.0'
  author: 'Maik van der Gaag'
}

metadata description = '''
Module for creating a API Infrastructure
'''

@description('The environment were the service is beign deployed to (tst, acc, prd, dev)')
param env string

@description('Name of the API Management instance. Must be globally unique.')
param name string

@description('The SKU of App Service Plan')
param sku string = 'S1'

@description('The version of the runtime')
param linuxFxVersion string = 'DOTNETCORE|8.0'

@description('The location of the resource')
param location string = resourceGroup().location

@description('Additional app settings')
param appSettings object = {}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: 'hp-${name}-${env}'
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
  kind: 'linux'
}

resource appService 'Microsoft.Web/sites@2023-12-01' = {
  name: 'api-${name}-${env}'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      alwaysOn: true
    }
    httpsOnly: true
  }
}

resource siteconfig 'Microsoft.Web/sites/config@2023-01-01' = {
  parent: appService
  name: 'appsettings'
  properties: union({
      XDT_MicrosoftApplicationInsights_Mode: 'Recommended'
    }, appSettings)
}

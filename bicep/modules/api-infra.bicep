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
param sku string = 'F1'

@description('The version of the runtime')
param linuxFxVersion string = 'DOTNETCORE|8.0'

@description('The location of the resource')
param location string = resourceGroup().location

@description('The URL of the repository')
param repositoryUrl string

@description('The branch of the repository')
param branch string = 'main'

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
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

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: 'api-${name}-${env}'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
    }
  }
}

resource srcControls 'Microsoft.Web/sites/sourcecontrols@2021-01-01' = {
  name: 'web'
  parent: appService
  properties: {
    repoUrl: repositoryUrl
    branch: branch
    isManualIntegration: true
  }
}

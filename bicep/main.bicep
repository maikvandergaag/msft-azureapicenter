targetScope = 'subscription'

metadata info = {
  title: 'Deploying solution for Azure API Center'
  description: 'Bicep Main file for deploying a solution for Azure API Center'
  version: '1.0.0'
  author: 'Maik van der Gaag'
}

metadata description = '''
Module for creating a new API Center and all the components needed for demonstration.
'''

@allowed([
  'tst'
  'acc'
  'prd'
  'dev'
])
@description('The environment were the service is beign deployed to (tst, acc, prd, dev)')
param env string

@description('Location for the resource.')
param location string = deployment().location

@description('Name of the API Management instance. Must be globally unique.')
param name string

@description('Title for the workspace within Azure API Center')
param apicentertitle string = 'API Center'

@description('Description for the workspace within Azure API Center')
param apicenterdescription string = apicentertitle

resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'sponsor-rg-${name}-${env}'
  location: location
  tags: {
    environment: env
    clean: 'false'
  }
}

module apicenter 'modules/apicenter.bicep' = {
  name: 'apicenter'
  params: {
    env: env
    name: name
    apicentertitle: apicentertitle
    apicenterdescription: apicenterdescription
    location: location
  }
  scope: rg
}

module apiinfra 'modules/api-infra.bicep' = {
  name: 'apiinfra-01'
  params: {
    env: env
    name: '${name}-01'
    location: location
    appSettings:{
      APPINSIGHTS_INSTRUMENTATIONKEY: insights.outputs.appInsightsKey
      APPLICATIONINSIGHTS_CONNECTION_STRING: insights.outputs.appInsightsConnectionString
  }
  }
  scope: rg
}

module apiinfra01 'modules/api-infra.bicep' = {
  name: 'apiinfra-02'
  params: {
    env: env
    name: '${name}-02'
    location: location
    appSettings:{
      APPINSIGHTS_INSTRUMENTATIONKEY: insights.outputs.appInsightsKey
      APPLICATIONINSIGHTS_CONNECTION_STRING: insights.outputs.appInsightsConnectionString
      ApplicationInsightsAgent_EXTENSION_VERSION: '~3'
  }
  }
  scope: rg
}

module insights 'modules/api-insights.bicep' = {
  name: 'insights'
  params: {
    env: env
    name: name
    location: location
  }
  scope: rg
}

module mi 'modules/managedidentity.bicep' = {
  name: 'mi'
  params: {
    env: env
    name: name
    location: location
  }
  scope: rg
}

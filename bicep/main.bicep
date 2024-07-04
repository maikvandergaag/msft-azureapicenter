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

@description('The URL of the repository')
param repositoryUrl string

resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'sponsor-rg-${name}-${env}'
  location: location
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
  name: 'apiinfra'
  params: {
    env: env
    name: name
    location: location
    repositoryUrl: repositoryUrl
  }
  scope: rg
}

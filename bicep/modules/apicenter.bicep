metadata info = {
  title: 'Azure API Center Module'
  description: 'Module for setting up Azure API Center'
  version: '1.0.0'
  author: 'Maik van der Gaag'
}

metadata description = '''
Module for creating a new API Center.
'''

@allowed([
  'tst'
  'acc'
  'prd'
  'dev'
])
@description('The environment were the service is beign deployed to (tst, acc, prd, dev)')
param env string

@description('Name of the API Management instance. Must be globally unique.')
param name string

@description('Location for the resource.')
param location string = resourceGroup().location

param apicentertitle string

param apicenterdescription string = apicentertitle

resource apicenter 'Microsoft.ApiCenter/services@2024-03-01' = {
  name: 'apicenter-${name}-${env}'
  location: location
  properties: {}
}

resource apicenterworkspace 'Microsoft.ApiCenter/services/workspaces@2024-03-01' = {
  parent: apicenter
  name: 'default'
  properties: {
    title: apicentertitle
    description: apicenterdescription
  }
}

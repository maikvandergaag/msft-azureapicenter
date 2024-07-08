metadata info = {
  title: 'Azure API Center API Module'
  description: 'Module for addin a API to Azure API Center'
  version: '1.0.0'
  author: 'Maik van der Gaag'
}

metadata description = '''
Module for creating a new API in API Center.
'''

@allowed([
  'tst'
  'acc'
  'prd'
  'dev'
])
@description('The environment were the service is beign deployed to (tst, acc, prd, dev)')
param env string

@description('Name of the API Workspace to add the API to.')
param apiworkspacename string

@description('Name of the API Management instance. Must be globally unique.')
param name string

@description('The name of an API to register in the API center.')
param apiName string

@description('The type of the API to register in the API center.')
@allowed([
  'rest'
  'soap'
  'graphql'
  'grpc'
  'webhook'
  'websocket'
])
param apiType string = 'rest'

resource apicenter 'Microsoft.ApiCenter/services@2024-03-01' existing = {
  name: 'apicenter-${name}-${env}'
}

resource apicenterworkspace 'Microsoft.ApiCenter/services/workspaces@2024-03-01' existing = {
  parent: apicenter
  name: apiworkspacename
}

resource apiCenterAPI 'Microsoft.ApiCenter/services/workspaces/apis@2024-03-01' = {
  parent: apicenterworkspace
  name: apiName
  properties: {
    title: apiName
    kind: apiType
    externalDocumentation: [
      {
        description: 'API Center documentation'
        title: 'API Center documentation'
        url: 'https://learn.microsoft.com/azure/api-center/overview'
      }
    ]
    contacts: [
      {
        email: 'apideveloper@familie-vandergaag.nl'
        name: 'API Developer'
        url: 'https://learn.microsoft.com/azure/api-center/overview'
      }
    ]
    customProperties: {}
    summary: 'This is a demo API, deployed using a template!'
    description: 'This is a demo API, deployed using a template!'
  }
}



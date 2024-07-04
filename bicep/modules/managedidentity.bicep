metadata info = {
  title: 'Managed Identity'
  description: 'Module for creating a Managed Identity'
  version: '1.0.0'
  author: 'Maik van der Gaag'
}

metadata description = '''
Module for creating a new Managed Identity
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

resource mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'mi-${name}-${env}'
  location: location
}

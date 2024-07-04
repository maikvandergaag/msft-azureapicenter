metadata info = {
  title: 'Azure API Insights Module'
  description: 'Module for setting up the application insights'
  version: '1.0.0'
  author: 'Maik van der Gaag'
}

metadata description = '''
Module for creating a application insights component
'''

@description('The environment were the service is beign deployed to (tst, acc, prd, dev)')
param env string

@description('Name of the API Management instance. Must be globally unique.')
param name string

param location string
param appInsightsName string = 'appInsights'

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'la-${name}-${env}'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    workspaceCapping: {}
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appinsights-${name}-${env}'
  location: location
  kind: 'other'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Bluefield'
    WorkspaceResourceId: workspace.id
    RetentionInDays: 90
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

output appInsightsId string = appInsights.id
output appInsightsKey string = appInsights.properties.InstrumentationKey
output appInsightsConnectionString string = appInsights.properties.ConnectionString

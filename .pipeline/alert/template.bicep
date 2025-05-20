param isAlertEnabled bool
param subscriptionId string = subscription().subscriptionId

param metricAlertsName string
param appInsightsName string
param webtestName string
param appInsightsResourceGroup string
param actiongroupResouceGroup string
param actiongroupName string

param webtestsId string = '/subscriptions/${subscriptionId}/resourceGroups/${appInsightsResourceGroup}/providers/microsoft.insights/webtests/${webtestName}'
param componentId string = '/subscriptions/${subscriptionId}/resourceGroups/${appInsightsResourceGroup}/providers/microsoft.insights/components/${appInsightsName}'
param actiongroupsId string = '/subscriptions/${subscriptionId}/resourceGroups/${actiongroupResouceGroup}/providers/microsoft.insights/actiongroups/${actiongroupName}'

resource metricAlertResource 'microsoft.insights/metricalerts@2018-03-01' = {
  name: metricAlertsName
  location: 'global'
  tags: {
    'hidden-link:${componentId}': 'Resource'
    'hidden-link:${webtestsId}': 'Resource'
  }
  properties: {
    description: 'Alert for "${webtestName}" availability test!!'
    severity: 1
    enabled: isAlertEnabled
    scopes: [
      webtestsId
      componentId
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      webTestId: webtestsId
      componentId: componentId
      failedLocationCount: 2
      'odata.type': 'Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria'
    }
    actions: [
      {
        actionGroupId: actiongroupsId
        webHookProperties: {}
      }
    ]
  }
}

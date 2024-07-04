$subscription = "f124b668-7e3d-4b53-ba80-09c364def1f3"

Set-AzContext -Subscription $subscription

New-AzDeployment -Location "WestEurope" -TemplateFile "main.bicep" -TemplateParameterFile "main.bicepparam"
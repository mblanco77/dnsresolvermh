#Connect-AzAccount
New-AzResourceGroup -Name rgresolvermh -Location eastus
New-AzResourceGroupDeployment -Name resolvermhdeploy -ResourceGroupName rgresolvermh -TemplateFile ./main.bicep
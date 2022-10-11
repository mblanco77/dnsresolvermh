#Connect-AzAccount
New-AzResourceGroup -Name rgresolvermh -Location eastus
$deployvpn = $true
New-AzResourceGroupDeployment -Name resolvermhdeploy -ResourceGroupName rgresolvermh -TemplateFile ./main.bicep -deployvpn $deployvpn
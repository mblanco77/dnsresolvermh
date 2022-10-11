param location string = resourceGroup().location
param deployvpn bool = true

@description('The base URI where artifacts required by this template are located.')
param _artifactsLocation string = 'https://raw.githubusercontent.com/mblanco77/dnsresolvermh/main'

module net 'modules/networking.bicep' = {
  name: 'Networking'
  params:{
    location: location
    deployvpn: deployvpn
  }
}

resource vnethub 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: 'hub-vnet'
}
resource vnetonprem 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: 'onprem-vnet'
}
module compmod 'modules/compute.bicep' = {
  name: 'Compute'
  params:{
    location: location
    _artifactsLocation: _artifactsLocation
  }
  dependsOn:[
    vnethub
    vnetonprem
  ]
}

output pass string = compmod.outputs.pass


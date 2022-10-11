param location string = resourceGroup().location
param deployvpn bool = true

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
  }
  dependsOn:[
    vnethub
    vnetonprem
  ]
}

output pass string = compmod.outputs.pass


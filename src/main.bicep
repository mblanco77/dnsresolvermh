param location string = resourceGroup().location
param deployvpn bool = true

@description('The base URI where artifacts required by this template are located.')
param _artifactsLocation string = 'https://raw.githubusercontent.com/mblanco77/dnsresolvermh/main'

module net 'modules/networking.bicep' = {
  name: 'Networking'
  params:{
    location: location
  }
}

module conn 'modules/connections.bicep' = {
  name: 'Connections'
  params:{
    location: location
    deployvpn: deployvpn
  }
  dependsOn:[
    net
  ]
}
module compmod 'modules/compute.bicep' = {
  name: 'Compute'
  params:{
    location: location
    _artifactsLocation: _artifactsLocation
  }
  dependsOn:[
    net
  ]
}

output pass string = compmod.outputs.pass

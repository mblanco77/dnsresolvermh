param location string = resourceGroup().location
param deployvpn bool = true

module net 'modules/networking.bicep' = {
  name: 'Networking'
  params:{
    location: location
    deployvpn: deployvpn
  }
}

module compmod 'modules/compute.bicep' = {
  name: 'Compute'
  params:{
    location: location
  }
}

output pass string = compmod.outputs.pass


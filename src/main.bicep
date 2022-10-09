param location string = resourceGroup().location

module net 'modules/networking.bicep' = {
  name: 'Networking'
  params:{
    location: location
  }
}

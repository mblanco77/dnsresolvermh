param location string = resourceGroup().location
@secure()
param adminPassword string = newGuid()


module modonprem 'compute/windowsvm.bicep' = {
  name: 'vm-onprem'
  params: {
    vmName: 'vm-onprem'
    adminPassword:adminPassword 
    adminUsername: 'azureuser'
    location: location
    virtualNetworkName: 'onprem-vnet'
    subnetName:'vmSubnet'
  }
}

module modhub 'compute/windowsvm.bicep' = {
  name: 'vm-hubmod'
  params: {
    vmName: 'vm-hub'
    adminPassword:adminPassword 
    adminUsername: 'azureuser'
    location: location
    virtualNetworkName: 'hub-vnet'
    subnetName:'vmSubnet'

  }
}

output pass string = adminPassword

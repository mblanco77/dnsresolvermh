param location string = resourceGroup().location
@secure()
param adminPassword string = newGuid()

@description('base url of the installer script')
param _artifactsLocation string

var configuration = {
  uriInstallScripts: '${_artifactsLocation}/src/scripts/installsoftware.ps1'
  uriInstallScriptsDNS: '${_artifactsLocation}/src/scripts/installsoftwaredns.ps1'
  scriptexednshub: './installsoftwarednshub.ps1'
  scriptexednsonprem: './installsoftwaredns.ps1 blob.core.windows.net 10.5.0.254'
  scriptexeonprem: './installsoftware.ps1'
  scriptexespoke: './installsoftware.ps1'
}

module modvmonprem 'compute/windowsvm.bicep' = {
  name: 'vm-onprem'
  params: {
    vmName: 'vm-onprem'
    adminPassword:adminPassword 
    adminUsername: 'azureuser'
    location: location
    virtualNetworkName: 'onprem-vnet'
    subnetName:'vmSubnet'
    scriptURL: configuration.uriInstallScripts
    scriptExecute: configuration.scriptexeonprem
  }
}

module modvmhub 'compute/windowsvm.bicep' = {
  name: 'vm-hub'
  params: {
    vmName: 'vm-hub'
    adminPassword:adminPassword 
    adminUsername: 'azureuser'
    location: location
    virtualNetworkName: 'hub-vnet'
    subnetName:'vmSubnet'
  }
}

module modvmapoke 'compute/windowsvm.bicep' = {
  name: 'vm-spoke'
  params: {
    vmName: 'vm-spoke'
    adminPassword:adminPassword 
    adminUsername: 'azureuser'
    location: location
    virtualNetworkName: 'spoke1-vnet'
    subnetName:'vmSubnet'

  }
}

module modvmdns 'compute/windowsvm.bicep' = {
  name: 'vm-dnsonprem'
  params: {
    vmName: 'vm-dnsonprem'
    adminPassword:adminPassword 
    adminUsername: 'azureuser'
    location: location
    virtualNetworkName: 'onprem-vnet'
    subnetName:'vmSubnet'
    scriptURL: configuration.uriInstallScriptsDNS
    scriptExecute: configuration.scriptexednsonprem

  }
}

output pass string = adminPassword

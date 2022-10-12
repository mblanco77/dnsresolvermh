@description('Username for the Virtual Machine.')
param adminUsername string

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

@description('Name of the virtual machine.')
param vmName string

@description('Allocation method for the Public IP used to access the Virtual Machine.')
@allowed([
  'Dynamic'
  'Static'
])
param publicIPAllocationMethod string = 'Dynamic'
@description('Is this VM using a static or dynamic IP?')
@allowed([
  'Dynamic'
  'Static'
])
param privateIPAllocationMethod string = 'Dynamic'

@description('set azure provided dns to nic')
@allowed([
  'Yes'
  'No'
])
param nicDns string = 'No'

@description('SKU for the Public IP used to access the Virtual Machine.')
@allowed([
  'Basic'
  'Standard'
])
param publicIpSku string = 'Basic'

@description('Size of the virtual machine.')
param vmSize string = 'Standard_D2s_v5'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name of the existing vnet')
param virtualNetworkName string

@description('Name of the existing vnet')
param subnetName string

@description('url of the installer script')
param scriptURL string = ''

@description('script exe')
param scriptExecute string = ''

var nicName = '${vmName}nic'
@description('name of the nic')
param privateIPAddress string = ''

var dnsLabelPrefix = toLower('${vmName}-${uniqueString(resourceGroup().id, vmName)}')

var publicIpName = '${vmName}PublicIP'

var nicIpConfigurationType = {
  Dynamic: {
    privateIPAllocationMethod: 'Dynamic'
    subnet: {
      id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
    }
    publicIPAddress: {
      id: pip.id
    }
  }
  Static: {
    privateIPAllocationMethod: 'Static'
    subnet: {
      id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
    }
    privateIPAddress: privateIPAddress
    publicIPAddress: {
      id: pip.id
    }
  }
}
var nicIpProperties = nicIpConfigurationType[privateIPAllocationMethod]
var nicipConfigurations = {
  ipConfigurations: [
    {
      name: 'ipConfig1'
      properties: nicIpProperties
    }
  ]
}
var nicdnsSettings = {
  dnsSettings: {
    dnsServers: [
      '168.63.129.16'
    ]
  }
}
var nicProperties = ((nicDns == 'No') ? nicipConfigurations : union(nicipConfigurations, nicdnsSettings))



resource pip 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: publicIpName
  location: location
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
  }
}

resource vnetExternal 'Microsoft.Network/virtualNetworks@2020-08-01' existing = {
  name : virtualNetworkName
}

resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: nicName
  location: location
  properties: nicProperties
  dependsOn:[
    vnetExternal
  ]
}

resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      osDisk: {
        createOption: 'fromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
  }
}

resource vmName_installcustomscript 'Microsoft.Compute/virtualMachines/extensions@2018-06-01' = if (length(scriptExecute)> 0) {
  parent: vm
  name: 'installcustomscript'
  location: location
  tags: {
    displayName: 'install software for Windows VM'
  }
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        scriptURL
      ]
    }
    protectedSettings: {
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File ${scriptExecute}'
    }
  }
}

output hostname string = pip.properties.dnsSettings.fqdn

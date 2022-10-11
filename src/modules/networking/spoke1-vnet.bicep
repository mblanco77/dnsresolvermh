param location string = resourceGroup().location

@description('VNet name')
param vnetName string = 'spoke1-vnet'

@description('VNet address prefix')
param vnetAddressPrefix string = '10.120.0.0/16'

@description('vm subnet name')
param spoke1SubnetName string = 'vmSubnet'

@description('vm subnet prefix')
param spoke1SubnetPrefix string = '10.120.1.0/24'

resource securityGroup 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: 'nsgspoke'
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-3389'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: spoke1SubnetName
        properties: {
          addressPrefix: spoke1SubnetPrefix
          networkSecurityGroup:securityGroup
        }
      }
    ]
  }
}

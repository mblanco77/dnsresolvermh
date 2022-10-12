param location string = resourceGroup().location

@description('VNet name')
param vnetName string = 'onprem-vnet'

@description('VNet address prefix')
param vnetAddressPrefix string = '192.168.0.0/16'

@description('Gateway subnet name')
param gatewaySubnetName string = 'GatewaySubnet'

@description('Gateway subnet prefix')
param gatewaySubnetPrefix string = '192.168.3.0/24'

@description('vm subnet name')
param vmSubnetName string = 'vmSubnet'

@description('vm subnet prefix')
param vmSubnetPrefix string = '192.168.1.0/24'

resource securityGroup 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: 'nsgonprem'
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
    dhcpOptions: {
      dnsServers:[
        '192.168.1.4'  
      ]
    }
    subnets: [
      {
        name: gatewaySubnetName
        properties: {
          addressPrefix: gatewaySubnetPrefix
        }
      }
      {
        name: vmSubnetName
        properties: {
          addressPrefix: vmSubnetPrefix
          networkSecurityGroup:{
            id:securityGroup.id
          }
        }
      }      
    ]
  }
}

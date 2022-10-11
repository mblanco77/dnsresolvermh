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
        name: gatewaySubnetName
        properties: {
          addressPrefix: gatewaySubnetPrefix
        }
      }
      {
        name: vmSubnetName
        properties: {
          addressPrefix: vmSubnetPrefix
        }
      }      
    ]
  }
}

param location string = resourceGroup().location

@description('VNet name')
param vnetName string = 'hub-vnet'

@description('VNet address prefix')
param vnetAddressPrefix string = '10.60.0.0/16'

@description('Gateway subnet name')
param gatewaySubnetName string = 'GatewaySubnet'

@description('Gateway subnet prefix')
param gatewaySubnetPrefix string = '10.60.3.0/24'

@description('Bastion subnet name')
param bastionSubnetName string = 'AzureBastionSubnet'

@description('Bastion subnet prefix')
param bastionSubnetPrefix string = '10.60.5.0/24'

@description('Firewall user traffic subnet name')
param firewallSubnetName string = 'AzureFirewallSubnet'

@description('Firewall user traffic subnet prefix')
param firewallSubnetPrefix string = '10.60.6.0/24'

@description('pvt dns resolver inbound subnet name')
param pvtDnsResolverInSubnetName string = 'pvtDnsResolverInSubnet'

@description('pvt dns resolver inbound subnet prefix')
param pvtDnsResolverInSubnetPrefix string = '10.60.0.0/26'

@description('pvt dns resolver outbound subnet name')
param pvtDnsResolverOutSubnetName string = 'pvtDnsResolverOutSubnet'

@description('pvt dns resolver outbound subnet prefix')
param pvtDnsResolverOutSubnetPrefix string = '10.60.0.64/26'

@description('vm subnet name')
param vmSubnetName string = 'vmSubnet'

@description('vm subnet prefix')
param vmSubnetPrefix string = '10.60.1.0/24'

resource securityGroup 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: 'nsghub'
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
        name: gatewaySubnetName
        properties: {
          addressPrefix: gatewaySubnetPrefix
        }
      }
      {
        name: bastionSubnetName
        properties: {
          addressPrefix: bastionSubnetPrefix
        }
      }
      {
        name: firewallSubnetName
        properties: {
          addressPrefix: firewallSubnetPrefix
        }
      }
      {
        name: pvtDnsResolverInSubnetName
        properties: {
          addressPrefix: pvtDnsResolverInSubnetPrefix
        }
      }
      {
        name: pvtDnsResolverOutSubnetName
        properties: {
          addressPrefix: pvtDnsResolverOutSubnetPrefix
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



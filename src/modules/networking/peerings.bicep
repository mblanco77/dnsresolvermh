param hubVnetName string = 'hub-vnet'
param spoke1VnetName string = 'spoke1-vnet'
param rgname string = 'rgresolvermh'


resource peer1 'microsoft.network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  name: '${hubVnetName}/hub-to-spoke1'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId(rgname, 'Microsoft.Network/virtualNetworks', spoke1VnetName)
    }
  }
}

resource peer2 'microsoft.network/virtualNetworks/virtualNetworkPeerings@2020-05-01' = {
  name: '${spoke1VnetName}/spoke1-to-hub'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId(rgname, 'Microsoft.Network/virtualNetworks', hubVnetName)
    }
  }
}



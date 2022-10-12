param location string = resourceGroup().location
param deployvpn bool = true



module peeringModule 'networking/peerings.bicep' = {
  name:'peeringsModule'
  params:{
    
  }
  dependsOn:[
    virtualNetworkGateway
  ]
}
module bastion 'networking/bastion.bicep' = {
  name: 'bastionhost'
  params: {
    location: location
    vnetName: 'hub-vnet' 
  }
}


module virtualNetworkGateway 'networking/VirtualNetworkGateway.bicep' = if (deployvpn == true) {
  name: 'VirtualNetworkGatewayModule'
  params: {
    enableBGP: false
    gatewayType: 'Vpn'
    location: location
    PublicIpAddressName: 'pip-vng-hub'
    rgName: resourceGroup().name 
    sku: 'Basic'
    SubnetName: 'GatewaySubnet'
    virtualNetworkGatewayName: 'hub-vng'
    VirtualNetworkName: 'hub-vnet'
    vpnType: 'RouteBased'
  }
}

module virtualNetworkGatewayOnprem 'networking/VirtualNetworkGateway.bicep' = if (deployvpn == true) {
  name: 'VirtualNetworkGatewayOnpremModule'
  params: {
    enableBGP: false
    gatewayType: 'Vpn'
    location: location
    PublicIpAddressName: 'pip-vng-onprem'
    rgName: resourceGroup().name 
    sku: 'Basic'
    SubnetName: 'GatewaySubnet'
    virtualNetworkGatewayName: 'onprem-vng'
    VirtualNetworkName: 'onprem-vnet'
    vpnType: 'RouteBased'
  }
}
module linkedTemplateGetIpOnprem 'networking/getiphub.bicep' = if (deployvpn == true) {
  name: 'linkedTemplateGetIpOnprem'
  params: {
    ipName: virtualNetworkGatewayOnprem.outputs.ipid
  }
  dependsOn: [
    virtualNetworkGatewayOnprem
  ]
}

module localNetworkGateway 'networking/LocalNetworkGateway.bicep' = if (deployvpn == true)  {
  name: 'LocalNetworkGateway'
  params: {
    addressPrefixes: [
      '192.168.0.0/16'
    ]
    gatewayIpAddress: linkedTemplateGetIpOnprem.outputs.ipoutgw
    localNetworkGatewayName: 'lng-onprem'
    location: location
  }
  dependsOn:[
    virtualNetworkGatewayOnprem
  ]
}

module connection 'networking/vpn.bicep' = if (deployvpn == true) {
  name: 'vpn'
  params: {
    connectionName: 'cnt-to-onprem'
    connectionType: 'IPSec'
    enableBgp: false
    localNetworkGatewayId: localNetworkGateway.outputs.lngid
    location: location
    sharedKey: 'resolvermh'
    virtualNetworkGatewayId: virtualNetworkGateway.outputs.vngid
  }
}
module linkedTemplateGetIpHub 'networking/getiphub.bicep' = if (deployvpn == true)  {
  name: 'linkedTemplateGetIpHub'
  params: {
    ipName: virtualNetworkGateway.outputs.ipid
  }
  dependsOn: [
    virtualNetworkGateway
  ]
}

module localNetworkGatewayonprem 'networking/LocalNetworkGateway.bicep' = if (deployvpn == true)  {
  name: 'LocalNetworkGatewayOnprem'
  params: {
    addressPrefixes: [
      '10.60.0.0/16'
      '10.120.0.0/16'
    ]
    gatewayIpAddress: linkedTemplateGetIpHub.outputs.ipoutgw
    localNetworkGatewayName: 'lng-hub'
    location: location
  }
  dependsOn:[
    virtualNetworkGateway
  ]
}

module connectiononprem 'networking/vpn.bicep' = if (deployvpn == true)  {
  name: 'vpnonprem'
  params: {
    connectionName: 'cnt-to-hub'
    connectionType: 'IPSec'
    enableBgp: false
    localNetworkGatewayId: localNetworkGatewayonprem.outputs.lngid
    location: location
    sharedKey: 'resolvermh'
    virtualNetworkGatewayId: virtualNetworkGatewayOnprem.outputs.vngid
  }
}

param location string = resourceGroup().location

module vnetModule 'networking/vnetdeploy.bicep' = {
  name:'vnet-hub'
  params:{
    vNetType: 'hub'
    location: location
  }
}

module vnetModulespoke 'networking/vnetdeploy.bicep' = {
  name:'vnet-spoke'
  params:{
    vNetType: 'spoke1'
    location: location
  }
}

module vnetModuleOnprem 'networking/vnetdeploy.bicep' = {
  name:'vnet-onprem'
  params:{
    vNetType: 'onprem'
    location: location
  }
}

module peeringModule 'networking/peerings.bicep' = {
  name:'peerings'
  params:{
    
  }
  dependsOn:[
    vnetModuleOnprem
    vnetModule
  ]
}

module virtualNetworkGateway 'networking/VirtualNetworkGateway.bicep' = {
  name: 'VirtualNetworkGateway'
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
  dependsOn:[
    vnetModule
  ]
}

module virtualNetworkGatewayOnprem 'networking/VirtualNetworkGateway.bicep' = {
  name: 'VirtualNetworkGatewayOnprem'
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
  dependsOn:[
    vnetModuleOnprem
  ]
}

module localNetworkGateway 'networking/LocalNetworkGateway.bicep' = {
  name: 'LocalNetworkGateway'
  params: {
    addressPrefixes: [
      '192.168.0.0/16'
    ]
    gatewayIpAddress: virtualNetworkGatewayOnprem.outputs.ip
    localNetworkGatewayName: 'lng-onprem'
    location: location
  }
}

module connection 'networking/vpn.bicep' = {
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

module localNetworkGatewayonprem 'networking/LocalNetworkGateway.bicep' = {
  name: 'LocalNetworkGatewayOnprem'
  params: {
    addressPrefixes: [
      '10.60.0.0/16'
    ]
    gatewayIpAddress: virtualNetworkGateway.outputs.ip
    localNetworkGatewayName: 'lng-hub'
    location: location
  }
}

module connectiononprem 'networking/vpn.bicep' = {
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


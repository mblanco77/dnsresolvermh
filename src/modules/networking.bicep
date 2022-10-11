param location string = resourceGroup().location

module vnetModule 'networking/vnetdeploy.bicep' = {
  name:'vnet-hubModule'
  params:{
    vNetType: 'hub'
    location: location
  }
}

module vnetModulespoke 'networking/vnetdeploy.bicep' = {
  name:'vnet-spokeModule'
  params:{
    vNetType: 'spoke1'
    location: location
  }
}

module vnetModuleOnprem 'networking/vnetdeploy.bicep' = {
  name:'vnet-onpremModule'
  params:{
    vNetType: 'onprem'
    location: location
  }
}




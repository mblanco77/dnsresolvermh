param location string = resourceGroup().location

@allowed([
  'hub'
  'spoke1'
  'onprem'
])
param vNetType string

module hub './hub-vnet.bicep' = if (vNetType == 'hub') {
  name: 'hub-vnet'
  params: {
    location:location
    // override defaults here
  }
}

module spoke1 'spoke1-vnet.bicep' = if (vNetType == 'spoke1'){
  name: 'spoke1-vnet'
  params: {
    location:location
    // override defaults here
  }
}

module onprem 'onprem-vnet.bicep' = if (vNetType == 'onprem'){
  name: 'onprem-vnet'
  params: {
    location:location
    // override defaults here
  }
}

// module spoke2 './spoke2-vnet.bicep' = if (vNetType == 'spoke2') {
//   name: 'spoke2-vnet'
//   params: {
//     // override defaults here
//   }
// }

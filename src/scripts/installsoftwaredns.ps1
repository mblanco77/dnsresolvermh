Install-WindowsFeature DNS -IncludeManagementTools
#Add-DnsServerConditionalForwarderZone -Name $args[0] -MasterServers $args[1]
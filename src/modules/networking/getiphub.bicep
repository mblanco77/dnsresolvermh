param ipName string

output ipoutgw string = reference(ipName, '2019-09-01').ipAddress

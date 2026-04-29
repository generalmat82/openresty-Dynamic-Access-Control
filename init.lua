secrets = require "secrets"
IPInSubnet = require("IPInSubnet")
blockedIPs = IPInSubnet:new()
allowedIPs = IPInSubnet:new()

for i in secrets.subnets.whitelist do
    allowedIPs:addSubnet(secrets.subnets.whitelist[i])
end

for i in secrets.subnets.blacklist do
    blockedIPs:addSubnet(secrets.subnets.blacklist[i])
end

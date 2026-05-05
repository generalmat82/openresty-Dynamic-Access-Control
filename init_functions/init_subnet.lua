local SECRETS = require("secrets")

local IPInSubnet = require("IPInSubnet")
local BLOCKED_IPS = IPInSubnet:new()
local ALLOWED_IPS = IPInSubnet:new()

for key,subnet in ipairs(SECRETS.subnets.whitelist) do
    ALLOWED_IPS:addSubnet(subnet)
end

for key,subnet in ipairs(SECRETS.subnets.blacklist) do
    BLOCKED_IPS:addSubnet(subnet)
end


local SUBNETS = {BLOCKED = BLOCKED_IPS,ALLOWED = ALLOWED_IPS}


return SUBNETS
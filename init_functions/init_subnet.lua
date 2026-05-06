local SECRETS = require("secrets")

-- Subnets
local ipmatcher = require("resty.ipmatcher")
local ALLOWED_IPS = ipmatcher.new(SECRETS.subnets.whitelist)
local BLOCKED_IPS = ipmatcher.new(SECRETS.subnets.blacklist)


local SUBNETS = {BLOCKED = BLOCKED_IPS,ALLOWED = ALLOWED_IPS}


return SUBNETS
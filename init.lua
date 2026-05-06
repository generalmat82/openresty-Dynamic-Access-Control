local SECRETS = require "secrets"
GEO = require 'resty.maxminddb'


-- Subnets
local ipmatcher = require("resty.ipmatcher")
ALLOWED_IPS = ipmatcher.new(SECRETS.subnets.whitelist)
BLOCKED_IPS = ipmatcher.new(SECRETS.subnets.blacklist)

-- Cache Initialization
BL_CACHE = ngx.shared.ip_blacklist_cache
WT_CACHE = ngx.shared.ip_whitelist_cache

require "secrets"
require "general_functions.redis_con"
GEO = require 'resty.maxminddb'


-- Subnets
local IPInSubnet = require("IPInSubnet")
BLOCKED_IPS = IPInSubnet:new()
ALLOWED_IPS = IPInSubnet:new()

for key,subnet in ipairs(SECRETS.subnets.whitelist) do
    ALLOWED_IPS:addSubnet(subnet)
end
for key,subnet in ipairs(SECRETS.subnets.blacklist) do
    BLOCKED_IPS:addSubnet(subnet)
end

-- Cache Initialization
BL_CACHE = ngx.shared.ip_blacklist_cache
WT_CACHE = ngx.shared.ip_whitelist_cache

-- GEO
GEO.init({
    city = SECRETS.geoip.geoip_db_path.geoip_city,
    asn = SECRETS.geoip.geoip_db_path.geoip_asn,
    country = SECRETS.geoip.geoip_db_path.geoip_country
})

-- REDIS
-- DB = REDIS_CON.get_redis_connection()
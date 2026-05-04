SECRETS = require "secrets"
GEO = require 'resty.maxminddb'


-- Subnets
local IPInSubnet = require("IPInSubnet")
BLOCKED_IPS = IPInSubnet:new()
ALLOWED_IPS = IPInSubnet:new()

for i in SECRETS.subnets.whitelist do
    ALLOWED_IPS:addSubnet(SECRETS.subnets.whitelist[i])
end

for i in SECRETS.subnets.blacklist do
    BLOCKED_IPS:addSubnet(SECRETS.subnets.blacklist[i])
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
REDIS_CON = require "general_functions.redis_con"
DB = REDIS_CON.get_redis_connection()
local secrets = require "secrets"
GEO = require 'resty.maxminddb'

-- Subnets
IPInSubnet = require("IPInSubnet")
BLOCKED_IPS = IPInSubnet:new()
ALLOWED_IPS = IPInSubnet:new()

for i in secrets.subnets.whitelist do
    ALLOWED_IPS:addSubnet(secrets.subnets.whitelist[i])
end

for i in secrets.subnets.blacklist do
    BLOCKED_IPS:addSubnet(secrets.subnets.blacklist[i])
end

-- Cache Initialization
LOCAL_BL_CACHE = ngx.shared.ip_blacklist_cache
LOCAL_WT_CACHE = ngx.shared.ip_whitelist_cache

-- GEO
GEO.init({
    city = secrets.geoip.geoip_db_path.geoip_city,
    asn = secrets.geoip.geoip_db_path.geoip_asn,
    country = secrets.geoip.geoip_db_path.geoip_country
})

-- REDIS
REDIS_CON = require "general_functions.redis_con"
DB = REDIS_CON.get_redis_connection()
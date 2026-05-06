local SECRETS = require "secrets"
GEO = require 'resty.maxminddb'


-- Subnets
local ipmatcher = require("resty.ipmatcher")
ALLOWED_IPS = ipmatcher.new(SECRETS.subnets.whitelist)
BLOCKED_IPS = ipmatcher.new(SECRETS.subnets.blacklist)

-- Cache Initialization
BL_CACHE = ngx.shared.ip_blacklist_cache
WT_CACHE = ngx.shared.ip_whitelist_cache

-- GEO
GEO.init({
    city = SECRETS.geoip.geoip_db_path.geoip_city,
    asn = SECRETS.geoip.geoip_db_path.geoip_asn,
    country = SECRETS.geoip.geoip_db_path.geoip_country
})

local SECRETS = require "secrets"
GEO = require 'resty.maxminddb'

-- Cache Initialization
BL_CACHE = ngx.shared.ip_blacklist_cache
WT_CACHE = ngx.shared.ip_whitelist_cache

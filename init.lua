local SECRETS = require "secrets"

-- Cache Initialization
BL_CACHE = ngx.shared.ip_blacklist_cache
WT_CACHE = ngx.shared.ip_whitelist_cache

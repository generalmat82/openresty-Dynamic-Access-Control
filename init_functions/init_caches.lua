local caches = {WT = ngx.shared.ip_whitelist_cache, BL = ngx.shared.ip_blacklist_cache}
return caches
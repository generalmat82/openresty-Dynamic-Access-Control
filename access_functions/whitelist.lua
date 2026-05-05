local WHITELIST = {}

function WHITELIST.whitelistCheck(whitelistKey,clientIP,SECRETS,DB)
    -- This function first verifies if the IP is in the local cache
    -- It then verifies if it is in the DB
    -- Finally it verifies if it is in an allowed subnet.
    if WT_CACHE:get(whitelistKey) == "true" then return true end
    if DB:get(whitelistKey) == "true" then
        WT_CACHE:set(whitelistKey,true,SECRETS.cache.wt_ttl)
        return true end
    if ALLOWED_IPS:isInSubnets(clientIP) == true then
        DB:set(whitelistKey,true)
        WT_CACHE:set(whitelistKey,true,SECRETS.cache.wt_ttl)
        return true end
end

return WHITELIST
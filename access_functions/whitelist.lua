local WHITELIST = {}

function WHITELIST.whitelistCheck(whitelistKey,clientIP,SECRETS,DB,CACHES)
    -- This function first verifies if the IP is in the local cache
    -- It then verifies if it is in the DB
    -- Finally it verifies if it is in an allowed subnet.
    if CACHES.WT:get(whitelistKey) == "true" then return true end
    if DB:get(whitelistKey) == "true" then
        CACHES.WT:set(whitelistKey,true,SECRETS.cache.wt_ttl)
        return true end
    local SUBNETS = require("init_functions.init_subnet")
    if SUBNETS.ALLOWED:match(clientIP) == true then
        DB:set(whitelistKey,true)
        CACHES.WT:set(whitelistKey,true,SECRETS.cache.wt_ttl)
        return true end
end

return WHITELIST
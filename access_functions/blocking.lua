local BLOCKING = {}

function BLOCKING.blockCheck(blockKey,clientIP,SECRETS,DB)
    -- This function verifies if the IP is already blocked.
    if BL_CACHE:get(blockKey) == "true" then
        -- the IP is in the blacklist cache.
        BLOCKING.retryAttempt(blockKey)
        ngx.exit(ngx.HTTP_FORBIDDEN)
    end
    if DB:get(blockKey) == "true" then
        BL_CACHE:set(blockKey, true, SECRETS.cache.bl_ttl)
        BLOCKING.retryAttempt(blockKey)
        ngx.exit(ngx.HTTP_FORBIDDEN)
    end
    local SUBNETS = require("init_functions.init_subnet")
    if SUBNETS.BLOCKED:match(clientIP) == true then
        DB:set(blockKey,true)
        BL_CACHE:set(blockKey,true,SECRETS.cache.bl_ttl)
        return true end
end

function BLOCKING.retryAttempt(blockKey)
    -- Actions to take if an IP retires once blocked
end

function BLOCKING.thresholdCheck(blockKey,countKey,SECRETS,DB)
    -- increments the count and set the expiration.
    -- also verifies if the threshold has been passed.
    local count, err = tonumber(DB:incr(countKey))
    if count == 1 then 
        -- Ensures that the count resets after the window.
        DB:expire(countKey, SECRETS.block.threshold_window) end
    if count > SECRETS.block.threshold_max then
        DB:set(blockKey, true)
        DB:expire(blockKey, SECRETS.block.block_time)
    end
end

function BLOCKING.geo_check(clientIP,blockKey,SECRETS,DB,GENERAL)
    -- block based on IP geolocation.
    local geo = require("init_functions.init_geo")
    local country = geo.lookup(clientIP, nil, 'country')
    if GENERAL.has_value(SECRETS.geoip.blocked_countries, country) then
        DB:set(blockKey, true)
        DB:expire(blockKey, SECRETS.block.block_time)
        BL_CACHE:set(blockKey,true,SECRETS.cache.bl_ttl)
        ngx.exit(ngx.HTTP_FORBIDDEN)
    end
end

return BLOCKING
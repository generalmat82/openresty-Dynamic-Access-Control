local BLOCKING = {}

function BLOCKING.blockCheck(blockKey,clientIP,SECRETS,DB,CACHES)
    -- This function verifies if the IP is already blocked.
    if CACHES.BL:get(blockKey) == "true" then
        -- the IP is in the blacklist cache.
        BLOCKING.retryAttempt(blockKey)
        ngx.exit(ngx.HTTP_FORBIDDEN)
    end
    if DB:get(blockKey) == "true" then
        CACHES.BL:set(blockKey, true, SECRETS.cache.bl_ttl)
        BLOCKING.retryAttempt(blockKey)
        ngx.exit(ngx.HTTP_FORBIDDEN)
    end
    local SUBNETS = require("init_functions.init_subnet")
    if SUBNETS.BLOCKED:match(clientIP) == true then
        DB:set(blockKey,true)
        CACHES.BL:set(blockKey,true,SECRETS.cache.bl_ttl)
        return true end
end

function BLOCKING.retryAttempt(blockKey)
    -- Actions to take if an IP retires once blocked
end

function BLOCKING.thresholdCheck(blockKey,countKey,SECRETS,DB,clientIP)
    -- increments the count and set the expiration.
    -- also verifies if the threshold has been passed.
    local count, err = tonumber(DB:incr(countKey))
    if count == 1 then 
        -- Ensures that the count resets after the window.
        DB:expire(countKey, SECRETS.block.threshold_window) end
    if count > SECRETS.block.threshold_max then
        DB:set(blockKey, true)
        DB:expire(blockKey, SECRETS.block.block_time)
        if SECRETS.notifications.enabled == true and SECRETS.notifications.block.enabled == true then
            local notify = require("general_functions.notif")
            local title = "Address blocked"
            local body = "Address has been blocked for extensive access: "..clientIP
            notify(title,SECRETS.notifications.block.notif_type,SECRETS.notifications.block.tag,body,SECRETS)
        end

    end
end

function BLOCKING.geo_check(clientIP,blockKey,SECRETS,DB,GENERAL,CACHES)
    -- block based on IP geolocation.
    local geo = require("init_functions.init_geo")
    local country = geo.lookup(clientIP, nil, 'country')
    if GENERAL.has_value(SECRETS.geoip.blocked_countries, country) then
        DB:set(blockKey, true)
        DB:expire(blockKey, SECRETS.block.block_time)
        CACHES.BL:set(blockKey,true,SECRETS.cache.bl_ttl)
        ngx.exit(ngx.HTTP_FORBIDDEN)
    end
end

return BLOCKING
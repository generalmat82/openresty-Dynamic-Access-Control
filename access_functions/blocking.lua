BLOCKING = {}

function BLOCKING.blockCheck(blockKey)
    -- This function verifies if the IP is already blocked.
    if BL_CACHE:get(blockKey) == "true" then
        -- the IP is in the blacklist cache.
        BLOCKING.retryAttempt(blockKey)
        ngx.exit(ngx.HTTP_FORBIDDEN)
    end
    if DB:get(blockKey) == "true" then
        BL_CACHE:set(blockKey, true, SECRETS.bl_ttl)
        BLOCKING.retryAttempt(blockKey)
        ngx.exit(ngx.HTTP_FORBIDDEN)
    end
end

function BLOCKING.retryAttempt(blockKey)
    -- Actions to take if an IP retires once blocked
end

function BLOCKING.thresholdCheck(blockKey,countKey)
    local count, err = tonumber(DB:incr(countKey))
    if count == 1 then 
        -- Ensures that the count resets after the window.
        DB:expire(countKey, SECRETS.block.threshold_window) end
    if count > SECRETS.block.threshold_max then
        DB:set(blockKey, true)
        DB:expire(blockKey, SECRETS.block.block_time)
    end

end
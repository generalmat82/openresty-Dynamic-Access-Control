LOCATION_CONTROL = {}

function LOCATION_CONTROL.check(blockKey, whitelistKey)
    -- This Functions determines if the request
    -- is accessing the dynamic whitelist URI or something else
    LOCATION_CONTROL.dynamic_whitelist(whitelistKey)
end

function LOCATION_CONTROL.dynamic_whitelist(whitelistKey)
    -- Function for the dynamic Whitelist,
    -- First checks if domain matches then checks if the location matches
    if ngx.var.server_name == SECRETS.dyn_wt.location.domain then
        if ngx.var.request_uri == SECRETS.dyn_wt.location.URI then
            DB:set(whitelistKey,true)
            DB:expire(whitelistKey,SECRETS.dyn_wt.duration)
        end
    end
end


function LOCATION_CONTROL.detectSuspiciousPatterns(request_uri, user_agent)
    for _, pattern in ipairs(SECRETS.path_blocks.locations) do
        if string.find(string.lower(request_uri), pattern) then
            return true
        end
    end
    return false
end

function LOCATION_CONTROL.sus(requestUri, blockKey)
    if LOCATION_CONTROL.detectSuspiciousPatterns(requestUri) then
        DB:set(blockKey, 1)
        DB:expire(blockKey, SECRETS.block.block_time * 5)
        ngx.exit(ngx.HTTP_FORBIDDEN)
    end
end
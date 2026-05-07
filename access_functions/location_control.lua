local LOCATION_CONTROL = {}

function LOCATION_CONTROL.check(blockKey, whitelistKey,SECRETS,DB,clientIP)
    -- This Functions determines if the request
    -- is accessing the dynamic whitelist URI or something else
    LOCATION_CONTROL.dynamic_whitelist(whitelistKey,SECRETS,DB,clientIP)
end

function LOCATION_CONTROL.dynamic_whitelist(whitelistKey,SECRETS,DB,clientIP)
    -- Function for the dynamic Whitelist,
    -- First checks if domain matches then checks if the location matches
    if ngx.var.server_name == SECRETS.dyn_wt.location.domain and ngx.var.request_uri == SECRETS.dyn_wt.location.URI then
            DB:set(whitelistKey,true)
            DB:expire(whitelistKey,SECRETS.dyn_wt.duration)
        if SECRETS.notifications.enabled == true and SECRETS.notifications.dyn_wt.enabled == true then
            local notify = require("general_functions.notif")
            local title = "Dynamic IP addition"
            local body = "IP has attempted to be added to whitelist: "..clientIP
            notify(title,SECRETS.notifications.dyn_wt.notif_type,SECRETS.notifications.dyn_wt.notif_tag,body,SECRETS)
        end
    end
end


function LOCATION_CONTROL.detectSuspiciousPatterns(request_uri,SECRETS)
    for _, pattern in ipairs(SECRETS.path_blocks.locations) do
        if string.find(string.lower(request_uri), pattern) then
            return true
        end
    end
    return false
end

function LOCATION_CONTROL.sus(requestUri, blockKey,DB,SECRETS,clientIP)
    if LOCATION_CONTROL.detectSuspiciousPatterns(requestUri) then
        DB:set(blockKey, 1)
        DB:expire(blockKey, SECRETS.block.block_time * 5)
        if SECRETS.notifications.enabled == true and SECRETS.notifications.block.enabled == true then
            local notify = require("general_functions.notif")
            local title = "Address blocked"
            local body = "Address has been blocked for accessing blocked locations: "..clientIP
            notify(title,SECRETS.notifications.block.notif_type,SECRETS.notifications.block.notif_tag,body,SECRETS)
        end
        ngx.exit(ngx.HTTP_FORBIDDEN)
    end
end

return LOCATION_CONTROL
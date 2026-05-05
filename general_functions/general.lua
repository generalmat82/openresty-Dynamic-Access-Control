
local GENERAL = {}


function GENERAL.getClientIP()
    -- Obtains the Client's IP through various means
    local clientIP = ngx.req.get_headers()["X-Real-IP"]
    if clientIP == nil then
        clientIP = ngx.req.get_headers()["X-Forwarded-For"]
    end
    if clientIP == nil then
        clientIP = ngx.var.remote_addr
    end
    return clientIP
end

function GENERAL.keyGenerator(clientIP)
    -- Generates Keys based on the ClientIP, allowing better readability
    local countKey = "limit:count:" .. clientIP
    local blockKey = "limit:block:" .. clientIP
    local whitelistKey = "whitelist:ip:"..clientIP
    return countKey, blockKey, whitelistKey
end

-- Source - https://stackoverflow.com/a/33511182
-- Posted by Oka, modified by community. See post 'Timeline' for change history
-- Retrieved 2026-02-02, License - CC BY-SA 3.0

function GENERAL.has_value (tab, val)
    -- Verifies if an array has a specifed value
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end
return GENERAL
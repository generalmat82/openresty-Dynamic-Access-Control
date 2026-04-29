
GENERAL = {}


function GENERAL.getClientIP()
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
    local countKey = "limit:count:" .. clientIP
    local blockKey = "limit:block:" .. clientIP
    return countKey, blockKey
end
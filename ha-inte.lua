local SECRETS = require "secrets"
local REDIS_CON = require "general_functions.redis_con"
local DB = REDIS_CON.get_redis_connection(SECRETS)
if ngx.var.uri == "/add" then
    local ipAddr = ngx.var.arg_ip
    DB:set("whitelist:ip:"..ipAddr,true)
    ngx.print("Added IP:"..ipAddr)
end
if ngx.var.uri == "/remove" then
    local ipAddr = ngx.var.arg_ip
    DB:del("whitelist:ip:"..ipAddr)
    ngx.print("Removed IP: "..ipAddr)
end

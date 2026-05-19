-- -File Import
local SECRETS = require "secrets"
local REDIS_CON = require "general_functions.redis_con"
local DB = REDIS_CON.get_redis_connection(SECRETS)
local cjson = require "cjson"

-- -Obtaining body
ngx.req.read_body()
local params = cjson.decode(ngx.req.get_body_data())

-- -Actions - Add
if params["action"] == "add" then
    DB:set("whitelist:ip:"..params["ip"],true)
    ngx.print("Added IP:"..params["ip"])
end

-- -Actions - Remove
if params["action"] == "remove" then
    DB:del("whitelist:ip:"..params["ip"])
    ngx.print("Removed IP: "..params["ip"])
end

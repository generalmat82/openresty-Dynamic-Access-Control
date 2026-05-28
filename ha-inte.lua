-- -File Import
local SECRETS = require "secrets"
local REDIS_CON = require "general_functions.redis_con"
local DB = REDIS_CON.get_redis_connection(SECRETS)
local cjson = require "cjson"

-- -Obtaining body
ngx.req.read_body()
local params = cjson.decode(ngx.req.get_body_data())
local whitelistKey = "whitelist:ip:"..params["ip"]

-- -Verif of HA entries
local wtVal = DB:get(whitelistKey) 

if not wtVal == "true#ha" or type(wtVal) == "nil" then
    ngx.print("entry not changed. Not entered via HA")
    ngx.exit()
end

-- -Actions - Add
if params["action"] == "add" then
    DB:set(whitelistKey,"true#ha")
    ngx.print("Added IP:"..params["ip"])
end

-- -Actions - Remove
if params["action"] == "remove" then
    DB:del(whitelistKey)
    ngx.print("Removed IP: "..params["ip"])
end

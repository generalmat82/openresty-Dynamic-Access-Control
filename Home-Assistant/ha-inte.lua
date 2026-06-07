--todo add a undefied/unknown/unavailable verification.


-- -File Import
local SECRETS = require "secrets"
local REDIS_CON = require "general_functions.redis_con"
local GENERAL = require "general_functions.general"
local DB = REDIS_CON.get_redis_connection(SECRETS)
local cjson = require "cjson"


local params = {old_ip = "", new_ip = ""}

-- -Obtaining parameters
ngx.req.read_body()
params = cjson.decode(ngx.req.get_body_data())
local raw_pool = DB:get("HA:ip_pool")
local ip_pool = cjson.decode(raw_pool)
-- -Remove old IP

local oldIPIndex = GENERAL.find(ip_pool,params["old_ip"])

if oldIPIndex ~= false then
    table.remove(ip_pool,oldIPIndex)
end

-- *Remove IP from whitelist if IP not in pool
if GENERAL.has_value(ip_pool, params["old_ip"]) == false then
    if DB:get("whitelsit:ip:"..params["old_ip"]) == "true#ha" then
        DB:del("whitelist:ip:"..params["old_ip"])
    end
end

-- -Add new IP
if GENERAL.has_value(ip_pool,params["new_ip"]) == false then
    if DB:get("whitelist:ip:"..params["new_ip"]) ~= "true" then
        DB:set("whitelist:ip:"..params["new_ip"], "true#ha")
    end
end

-- -Add New IP to pool
table.insert(ip_pool,params["new_ip"])
DB:set("HA:ip_pool",cjson.encode(ip_pool))
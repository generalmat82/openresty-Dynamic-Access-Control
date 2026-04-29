local redis = require "resty.redis"
local secrets = require "secrets"
REDIS_CON = {}

function REDIS_CON.close_redis(red)
    if not red then
        return
    end
    local ok, err = red:set_keepalive(secrets.pool_max_idle_time, secrets.pool_size)
    if not ok then
        ngx.say("Redis connection error: ", err)
        return red:close()
    end
end

function REDIS_CON.get_redis_connection()
    -- connect
    local redisdb = redis:new()
    redisdb:set_timeout(secrets.redis.timeout)
    local ok, err = redisdb:connect(secrets.redis.host, secrets.redis.port, secrets.redis.pool_config)
    if not ok then
        ngx.log(ngx.ERR, "Could not connect to redis: ", err)
        REDIS_CON.close_redis(redisdb)
        ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end
    -- login
    local connCount = redisdb:get_reused_times()
    if 0 == connCount then
        local ok, err = redisdb:auth(secrets.redis_auth)
        if not ok then
            ngx.log(ngx.ERR, "Failed auth: ", err)
            REDIS_CON.close_redis(redisdb)
            ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
        end
    end
    return redisdb
end

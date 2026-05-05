local redis = require "resty.redis"
local REDIS_CON = {}

function REDIS_CON.close_redis(red,SECRETS)
    if not red then
        return
    end
    local ok, err = red:set_keepalive(SECRETS.pool_max_idle_time, SECRETS.pool_size)
    if not ok then
        ngx.say("Redis connection error: ", err)
        return red:close()
    end
end

function REDIS_CON.get_redis_connection(SECRETS)
    -- connect
    local redisdb = redis:new()
    redisdb:set_timeout(SECRETS.redis.timeout)
    local ok, err = redisdb:connect(SECRETS.redis.host, SECRETS.redis.port, SECRETS.redis.pool_config)
    if not ok then
        ngx.log(ngx.ERR, "Could not connect to redis: ", err)
        REDIS_CON.close_redis(redisdb)
        ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end
    -- login
    local connCount = redisdb:get_reused_times()
    if 0 == connCount then
        local ok, err = redisdb:auth(SECRETS.redis.auth.user,SECRETS.redis.auth.password)
        if not ok then
            ngx.log(ngx.ERR, "Failed auth: ", err)
            REDIS_CON.close_redis(redisdb)
            ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
        end
    end
    return redisdb
end

return REDIS_CON
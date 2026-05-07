-- -File importation
local GENERAL = require "general_functions.general"
local BLOCKING = require "access_functions.blocking"
local LOCATION_CONTROL = require "access_functions.location_control"
local WHITELIST = require "access_functions.whitelist"
local REDIS_CON = require "general_functions.redis_con"
local SECRETS = require "secrets"
-- -Obtain basic information
local clientIP = GENERAL.getClientIP()
local countKey, blockKey, whitelistKey = GENERAL.keyGenerator(clientIP)
local CACHES = require("init_functions.init_caches")
local DB = REDIS_CON.get_redis_connection(SECRETS)

if WHITELIST.whitelistCheck(whitelistKey,clientIP,SECRETS,DB,CACHES) then return end

BLOCKING.blockCheck(blockKey,clientIP,SECRETS,DB,CACHES)

BLOCKING.thresholdCheck(blockKey,countKey,SECRETS,DB,clientIP)

BLOCKING.geo_check(clientIP,blockKey,SECRETS,DB,GENERAL)

LOCATION_CONTROL.check(blockKey,whitelistKey,SECRETS,DB,clientIP)

REDIS_CON.close_redis(DB,SECRETS)
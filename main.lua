-- -File importation
local GENERAL = require "general_functions.general"
local METRICS = require "general_functions.metrics"
local BLOCKING = require "access_functions.blocking"
local LOCATION_CONTROL = require "access_functions.location_control"
local WHITELIST = require "access_functions.whitelist"
local REDIS_CON = require "general_functions.redis_con"
local SECRETS = require "secrets"
-- -Obtain basic information
local clientIP = GENERAL.getClientIP()
local countKey, blockKey, whitelistKey = GENERAL.keyGenerator(clientIP)

local DB = REDIS_CON.get_redis_connection(SECRETS)

WHITELIST.whitelistCheck(whitelistKey,clientIP,SECRETS,DB)

BLOCKING.blockCheck(blockKey,SECRETS,DB)

BLOCKING.thresholdCheck(blockKey,countKey,SECRETS,DB)

BLOCKING.geo_check(clientIP,blockKey,SECRETS,DB,GENERAL)

LOCATION_CONTROL.check(blockKey,whitelistKey,SECRETS,DB)

REDIS_CON.close_redis(DB,SECRETS)
-- -File importation
require "general_functions.general"
require "general_functions.metrics"
require "access_functions.blocking"
require "access_functions.location_control"
require "access_functions.whitelist"
-- -Obtain basic information
local clientIP = GENERAL.getClientIP()
local countKey, blockKey, whitelistKey = GENERAL.keyGenerator(clientIP)

DB = REDIS_CON.get_redis_connection()

WHITELIST.whitelistCheck(whitelistKey,clientIP)

BLOCKING.blockCheck(blockKey)

BLOCKING.thresholdCheck(blockKey,countKey)

BLOCKING.geo_check(clientIP,blockKey)

LOCATION_CONTROL.check(blockKey,whitelistKey)
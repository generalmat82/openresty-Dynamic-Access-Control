-- -File importation
GENERAL = require "general_functions.general"
METRICS = require "general_functions.metrics"
BLOCKING = require "access_functions.blocking"
LOCATION_CONTROL = require "access_functions.location_control"
WHITELIST = require "access_functions.whitelist"
-- -Obtain basic information
local clientIP = GENERAL.getClientIP()
local countKey, blockKey, whitelistKey = GENERAL.keyGenerator(clientIP)

WHITELIST.whitelistCheck(whitelistKey,clientIP)

BLOCKING.blockCheck(blockKey)

BLOCKING.thresholdCheck(blockKey,countKey)

BLOCKING.geo_check(clientIP,blockKey)

LOCATION_CONTROL.check(blockKey,whitelistKey)
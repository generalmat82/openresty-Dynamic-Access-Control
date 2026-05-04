-- -File importation
local general = require "general_functions.general"


-- -Obtain basic information
local clientIP = general.getClientIP()
local countKey, blockKey, whitelistKey = general.keyGenerator(clientIP)

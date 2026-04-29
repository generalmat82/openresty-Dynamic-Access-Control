-- -File importation
local secrets = require "secrets"
local general = require "general_functions.general"


-- -Obtain basic information
local clientIP = general.getClientIP()
local countKey, blockKey = general.keyGenerator(clientIP)

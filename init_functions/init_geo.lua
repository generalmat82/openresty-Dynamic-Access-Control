local SECRETS = require("secrets")

local geo = require("resty.maxminddb")
if not geo.initted() then
    geo.init({
        city = SECRETS.geoip.geoip_db_path.geoip_city,
        asn = SECRETS.geoip.geoip_db_path.geoip_asn,
        country = SECRETS.geoip.geoip_db_path.geoip_country
    })
end
return geo
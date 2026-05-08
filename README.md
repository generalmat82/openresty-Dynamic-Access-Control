# openresty-Dynamic-Access-Control
> [!WARNING]
> I am not a cybersecurity expert, I am not responsible for any leaks.

> [!NOTE]
> This has only been tested using openresty

This project contains multiple scripts that allow for access Control with Openresty with lua.
It's capacities are the following:
- Rate limiting (Blocking an IP once they have reached x requests in y seconds)
- GeoIP blocking (Blocking based on the location of an IP)
- Path blocking (Blocking based on what path is being accessed)
- Static whitelist
- Dynamic whitelist
- Subnet bassed whitelist
- Metrics gathering
- Centrally managed via 1 main setting file (secrets.lua)
- apprise notifications

# Dependencies:
- Redis database
- Openresty
- OPM PACKAGES:
  - knyar/nginx-lua-prometheus           0.20240525
  - anjia0532/lua-resty-maxminddb        1.3.7
  - xiangnanscu/lua-resty-ipmatcher      0.31
  - ledgetech/lua-resty-http             0.17.1
- libmaxminddb0
- libmaxminddb-dev


# TODO:
- Improve documentation for install
- add metrics
- final tests
- bug fixes

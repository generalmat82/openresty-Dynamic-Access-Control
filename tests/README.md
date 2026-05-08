The tests are simple python scripts, utilizing requests library.
Using header "X-Real-IP" to fake IP addresses.

Tests are created in a seperate file and is added to test_mngr.

# secrets values expected for tests:
```lua
SECRETS.subnets.whitelist = {"7.7.7.0/24"}
SECRETS.subnets.blacklist = {"8.8.8.0/24"}
SECRETS.geoip.blocked_countries = {"RU"}
SECRETS.cache.bl_ttl = 5
SECRETS.cache.wt_ttl = 10
SECRETS.block.threshold_window = 10
SECRETS.block.threshold_max = 5
SECRETS.block.block_time = 20
SECRETS.dyn_wt.location.URI = "/whitelist"
SECRETS.dyn_wt.duration = 20
SECRETS.path_blocks.duration = 20
SECRETS.path_blocks.locations = {"^/%.git.*"}
```

# Implemented tests:
## Test 1: Allow test
This is a simple test to ensure normal requests are allowed.
Sends 1 request and expects status code 200.

Params: url, src_addr
Using IP: 1.1.1.1

## Test 2: Block test
This test attempts to get block while ensuring we don't get blocked early or too late.
Using the max time(time) and max requests(n) calculations are made to find an interval between queries.
It then makes a request and verifies the status code.
If it gets status 403 before n+1 fail. If it does not get status 403 after n+1 fail.

Params: url, src_addr, n(max requests), time
Using IP: 2.2.3.3

## Test 3: Expire test
Using the block from test 2. It connects to DB and verifies if the block still exists and has a TTL.
If the block dosen't have a TTL, fail. If block has a TTL, wait until TTL is over.
Once the TTL is over it tries to connect to the proxy.
Expects Status code 200.

Params: url, src_addr, DB_INFO
Using IP: 2.2.3.3

## Test 4: Geo block test
This test will be using a russian IP to attempt a geoblock.
The test is done in 1 queries. 
Expects 304 else fails

Params: url, src_addr
Using IP: 2.60.0.4

## Test 5: Sus access test
This Test tries to access /.git and should be blocked when doing so.
Expects 304 else fails

Params: url, src_addr
Using IP: 5.5.5.5

## Test 6: dyn_wt test
This test is a bit more complicated then most as we cannot have a status based answer on if we are whitelisted.
There is also more things to verify.
Instead we will do the following:
1. Querry dyn_wt location
    - Expected results would be 404 or 200
2. Verify DB, ensuring TTL
    - Expected would be a value above 0
3. Attempt to access /.git
    - Expected 404 or 200
4. Attempt to get block similarly to test 2
    - Expected to get 200 everytime.


| Params name | Description |
| --- | --- |
| wt_url | dyn_wt url |
| src_addr | source address |
| loc_url | url for the sus access |
| blo_url | url for brute force |
| n | max ammount of querries |
| time | time window to reach n+1 in seconds |
| DB_INFO | dict with DB connect info |
Using IP: 6.6.6.6

## Test 7: subnet whitelist test
This test will send a query in the whitelisted subnet.
It will then connect to the DB to verify it is whitelisted.

Params: url, src_addr, DB_INFO
Using IP: 7.7.7.7

## Test 8: Subnet blacklist test
This test will send a query in the blacklisted subnet.
Expects 403, else fails

Params: url, src_addr
Using IP: 8.8.8.8
The tests are simple python scripts, utilizing requests library.
Using header "X-Real-IP" to fake IP addresses.

Tests are created in a seperate file and is added to test_mngr.

# Recomended secrets values:
- bl_ttl = 5


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

# TODO:
- test for dyn_wt
- test for sus access
- test for geo block
- test for subnet whitelist
- test for subnet blocklist
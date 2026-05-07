The tests are simple python scripts, utilizing requests library.
Using header "X-Real-IP" to fake IP addresses.

Tests are created in a seperate file and is added to test_mngr.

Test recomendations: make times low.

# TODO:
- test ensuring expiry of blocks
- test for dyn_wt
- test for sus access
- test for geo block
- test for subnet whitelist
- test for subnet blocklist
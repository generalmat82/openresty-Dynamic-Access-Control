URL = "http://10.0.5.31"
DB_INFO = {
    "USER": "superadmin",
    "PASSWORD": "P@ssword",
    "PORT": 6379,
    "HOST": "127.0.0.1",
    "decode_responses": True
}


def clean_db(keys:list[str]) -> bool:
    """Remove specified keys from the DB.

    Args:
        keys (list[str]): List of keys to delete from DB
    Returns:
        bool: True if DB cleaned, False if DB not cleaned
    """
    import redis
    import requests

    client = redis.Redis(
        host=DB_INFO["HOST"],
        port=DB_INFO["PORT"],
        username=DB_INFO["USER"],
        password=DB_INFO["PASSWORD"],
        decode_responses=DB_INFO["decode_responses"]
    )
    requests.get(URL+":4956/flush")

    try:
        deleted = client.delete(*keys)
    except redis.RedisError as exc:
        print("Failed to clean Redis keys:", exc)
        return False

    print(f"Cleaned Redis keys ({deleted} deleted):", ", ".join(keys))
    return True


def main():
    test_keys = [
        "limit:count:1.1.1.1",
        "limit:block:2.2.3.3",
        "limit:count:2.2.3.3",
    ]

    if not clean_db(test_keys):
        print("Unable to clean test Redis keys. Aborting tests.")
        exit(50)

    print("TEST 1: Allow test")
    from allow_test import allow_test
    if not allow_test(URL, "1.1.1.1"):
        print("Necessary Pass required")
        exit(1)

    print("TEST 2: Block threshold test")
    from block_test import block_test
    if not block_test(URL, "2.2.3.3", 5, 2):
        print("Block test failed")
        exit(2)

    print("TEST 3: Expiry check")
    from expiry_test import expiry_test
    if not expiry_test(URL, "2.2.3.3", DB_INFO):
        print("expiry not working")
        exit(3)
    
    print("TEST 4: Geo block")
    from geo_test import geo_test
    if not geo_test(URL,"2.60.0.4"):
        print("Geo IP not blocked")
        exit(4)

    print("TEST 5: Location based block")
    from sus_test import sus_test
    if not sus_test(URL+"/.git","5.5.5.5"):
        print("Access to /.git was not blocked")
        exit(5)

    print("TEST 6: dynamic whitelist test")
    from dyn_wt_test import dyn_wt_test
    if not dyn_wt_test(URL+"/whitelist","6.6.6.6",URL+"/.git",URL,5,2,DB_INFO):
        print("Test failed, dynamic whitelist does not work.")
        exit(6)

    print("All tests passed")
    clean_db(test_keys)


if __name__ == "__main__":
    main()
# end main


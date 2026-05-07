URL = "http://a.b.c.d"
DB_USER = None
DB_PASSWORD = None

def clean_db(keys:list[str], host:str="127.0.0.1", port:int=6379, username:str|None=None, password:str|None=None):
    """Remove specified keys from the DB.

    Args:
        keys (list[str]): List of keys to delete from DB
        host (str, optional): Location of DB. Defaults to "127.0.0.1".
        port (int, optional): Port of DB. Defaults to 6379.
        username (str|None, optional): Username of DB. Defaults to None.
        password (str|None, optional): Password of DB. Defaults to None.

    Returns:
        bool: True if DB cleaned, False if DB not cleaned
    """
    import redis
    import requests

    client = redis.Redis(
        host=host,
        port=port,
        username=username,
        password=password,
        decode_responses=True
    )
    requests.get(URL+":4956")

    try:
        deleted = client.delete(*keys)
    except redis.RedisError as exc:
        print("Failed to clean Redis keys:", exc)
        return False

    print(f"Cleaned Redis keys ({deleted} deleted):", ", ".join(keys))
    return True


def main():
    test_keys = [
        "limit:block:1.1.1.1",
        "limit:count:1.1.1.1",
        "whitelist:ip:1.1.1.1",
        "limit:block:2.2.2.2",
        "limit:count:2.2.2.2",
        "whitelist:ip:2.2.2.2",
    ]

    if not clean_db(test_keys, username=DB_USER, password=DB_PASSWORD):
        print("Unable to clean test Redis keys. Aborting tests.")
        exit(50)

    print("TEST 1: Allow test")
    from allow_test import allow_test
    if not allow_test(URL, "1.1.1.1"):
        print("Necessary Pass required")
        exit(1)

    print("TEST 2: Block threshold test")
    from block_test import block_test
    if not block_test(URL, "2.2.2.2", 5, 10):
        print("Block test failed")
        exit(2)

    print("All tests passed")
    clean_db(test_keys,username=DB_USER, password=DB_PASSWORD)


if __name__ == "__main__":
    main()
# end main


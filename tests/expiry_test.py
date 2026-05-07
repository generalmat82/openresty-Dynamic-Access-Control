def expiry_test(url:str,src_addr:str,DB_INFO:dict) -> bool:
    """using the block from test 2, will connect to DB and verify TTL.
    Also tests once expired.
    
    Args:
        url (str): url to test after expiry
        src_addr (str): src_addr used in test 2
        DB_INFO (dict): info of the DB connection

    Returns:
        bool: true is passed, false is failed.
    """
    import redis
    import requests
    from time import sleep
    client = redis.Redis(
        host=DB_INFO["HOST"],
        port=DB_INFO["PORT"],
        username=DB_INFO["USER"],
        password=DB_INFO["PASSWORD"],
        decode_responses=DB_INFO["decode_responses"]
    )
    block_ttl = client.ttl(f"limit:block:{src_addr}")
    if block_ttl == -2:
        print("\tTest failed: block does not exist")
        return False
    elif block_ttl == -1:
        print("\tTest failed: block does not have an expiry")
        return False
    sleep(block_ttl) # type: ignore
    r = requests.get(url,headers={"X-Real-IP": src_addr})
    if r.status_code == 200:
        print("\tTest passed: block expired and query was allowed")
        return True
    else:
        print("\tTest failed: block expired but query was blocked")
        return False

def dyn_wt_test(wt_url:str,src_addr:str,loc_url:str,blo_url:str, n:int, time:int,DB_INFO:dict) -> bool:
    """Tests the dynamic whitelist

    Args:
        wt_url (str): dyn_wt url
        src_addr (str): source address
        loc_url (str): url for the sus access
        blo_url (str): url for brute force
        n (int): max ammount of querries
        time (int): time window to reach n+1 in seconds
        DB_INFO (dict): dict with DB connect info

    Returns:
        bool: true if passed False if failed
    """
    import requests
    import redis
    from time import sleep
    
    # - 1. Querry dyn_wt location
    r1 = requests.get(wt_url,headers={"X-Real-IP": src_addr})
    if not r1.status_code in [200,404]:
        print(f"\tTest Failed: Could not add to dyn_wt")
        return False

    # - 2. Verify DB, ensuring TTL
    client = redis.Redis(
        host=DB_INFO["HOST"],
        port=DB_INFO["PORT"],
        username=DB_INFO["USER"],
        password=DB_INFO["PASSWORD"],
        decode_responses=DB_INFO["decode_responses"]
    )
    wt_ttl = client.ttl(f"whitelist:ip:{src_addr}")
    if wt_ttl == -2:
        print("\tTest failed: Whitelist entry does not exist")
        return False
    if wt_ttl == -1:
        print("\tTest failed: TTL not set")
        return False

    # - 3. Attempt to access /.git
    r2 = requests.get(loc_url,headers={"X-Real-IP": src_addr})
    if not r2.status_code in [200,404]:
        print(f"Test failed: location check failed expected 200 or 404, got: {r2.status_code}")
        return False

    # - 4. Attempt to get block similarly to test 2
    def block_test(url:str, src_addr:str, n:int, time:int) -> bool:
        """attempts to get blocked.

        Args:
            url (str): url to query
            src_addr (str): source address for the "X-Real-IP" header
            n (int): max amount of queries (threshold in secrets.lua)
            time (int): time window to reach n+1 in seconds

        Returns:
            bool: true if not blocked, false if blocked
        """
        session = requests.Session()

        # threshold_max is the number of allowed requests within the time window.
        # We send a few more requests to force the block condition.
        allowed_requests = n
        total_requests = n + 2
        interval = max(0.01, (time - 1) / total_requests)

        blocked_seen = False
        for request_index in range(1, total_requests + 1):
            r = session.get(url, headers={"X-Real-IP": src_addr})
            status = r.status_code
            if request_index <= allowed_requests:
                if status == 403:
                    return False
            else:
                if status == 403:
                    blocked_seen = True
                    break
            sleep(interval)

        if blocked_seen:
            return False

        return True
    if block_test(blo_url,src_addr,n,time):
        print("Test passed: Whitelist was successful")
        return True
    return False


if __name__ == "__main__":
    print("dynamic whitelist test:")
    from test_mngr import URL, DB_INFO, clean_db
    if not dyn_wt_test(URL+"/whitelist","6.6.6.6",URL+"/.git",URL,5,10,DB_INFO):
        print("Test failed: dynamic whitelist does not work.")
# end main
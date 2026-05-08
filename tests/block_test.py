def block_test(url:str, src_addr:str, n:int, time:int) -> bool:
    """queries the url within time-1 until n+2 requests

    Args:
        url (str): url to query
        src_addr (str): source address for the "X-Real-IP" header
        n (int): max ammount of querries(threshhold in secrets.lua)
        time (int): time window to reach n+1 in seconds
    
    Returns:
        bool: true if passed False if failed
    """
    import requests
    from time import sleep

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
                print(f"\tTest failed on request {request_index}: expected 200, got 403")
                return False
        else:
            if status == 403:
                blocked_seen = True
                break
        sleep(interval)

    if blocked_seen:
        print(f"\tTest passed: threshold block triggered after {allowed_requests} allowed requests")
        return True

    print(f"\tTest failed: block was not triggered after {allowed_requests} allowed requests")
    return False

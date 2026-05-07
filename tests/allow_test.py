def allow_test(url:str,src_addr:str) -> bool:
    """simple query to verify normal requests

    Args:
        url (str): url to query
        src_addr (str): source address for the "X-Real-IP" header

    Returns:
        bool: true if passed False if failed
    """
    import requests
    r = requests.get(url,headers={'X-Real-IP': src_addr})
    if r.status_code == 200:
        print(f"\tTest passed, expected: 200, received: {r.status_code}")
        return True
    else:
        print(f"\tTest failed, expected: 200, received: {r.status_code}")
        return False


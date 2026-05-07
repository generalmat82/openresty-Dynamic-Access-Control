def geo_test(url:str, src_addr:str) -> bool:
    """Ensures Geo block is functional

    Args:
        url (str): url to query
        src_addr (str): source address for the "X-Real-IP" header

    Returns:
        bool: true if passed False if failed
    """
    import requests

    r = requests.get(url, headers={"X-Real-IP": src_addr})
    if r.status_code == 304:
        print(f"\tTest passed, expected: 304, received: {r.status_code}")
        return True
    else:
        print(f"\tTest failed, expected: 304, received: {r.status_code}")
        return False
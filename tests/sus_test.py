def sus_test(url:str,src_addr:str) -> bool:
    """Attempts to get blocked based on accessed location.

    Args:
        url (str): url to query
        src_addr (str): source address for the "X-Real-IP" header

    Returns:
        bool: true if passed False if failed
    """
    import requests

    r = requests.get(url, headers={"X-Real-IP": src_addr})
    if r.status_code == 403:
        print(f"\tTest passed, expected: 403, received: {r.status_code}")
        return True
    else:
        print(f"\tTest failed, expected: 403, received: {r.status_code}")
        return False

if __name__ == "__main__":
    print("Location based block test:")
    from test_mngr import URL, DB_INFO, clean_db
    if not sus_test(URL+"/.git","5.5.5.5"):
        print("Test failed: access to /.git was not blocked")
# end main
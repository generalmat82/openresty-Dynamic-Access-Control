def sub_wt_test(url:str,src_addr:str,DB_INFO:dict) -> bool:
    """Verifies the subnet whitelist

    Args:
        url (str): url to query
        src_addr (str): source address for the "X-Real-IP" header
        DB_INFO (dict): dict with DB connect info

    Returns:
        bool: true if passed False if failed
    """
    import redis
    import requests
    r1 = requests.get(url,headers={"X-Real-IP": src_addr})
    if not r1.status_code == 200:
        print("\tTest failed: could not access URL")
        return False
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
    print("\tTest passed: Subnet whitelist fonctional")
    return True

if __name__ == "__main__":
    print("Subnet whitelist test:")
    from test_mngr import URL, DB_INFO, clean_db
    clean_db(["whitelist:ip:7.7.7.7"])
    if not sub_wt_test(URL+"/whitelist","7.7.7.7",DB_INFO):
        print("Test failed: subnet whitelist not working")
# end main
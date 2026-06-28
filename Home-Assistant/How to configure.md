# How to configure the Home Assistant link.

1. Enable the HA sync server on nginx.conf
2. Enter the following in the configuration.yaml file. (Make sure to change the URL accordingly)
```yaml
rest_command:
  proxy:
    url: http://<proxy_ip_address>:57880/
    method: POST
    payload: '{"new_ip":"{{ new_ip }}","old_ip":"{{ old_ip }}"}'
    content_type:  'application/json; charset=utf-8'
```
3. Import the blueprint using the following link: `https://github.com/generalmat82/openresty-Dynamic-Access-Control/blob/main/Home-Assistant/Blueprint.yaml`
4. Create the automation from the blueprint.
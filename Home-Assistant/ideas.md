# Change of plan:
HA will send the old and new IP to proxy and proxy will do the processing.
This is because the processing in HA automation is too complicated to change.


# Ideas for the automation
# Inputs
the blueprint could have 2 inputs:
input 1(in1): ip entities - multiple allowed

Found this online: [Trigger based template sensor to store global variables](https://community.home-assistant.io/t/trigger-based-template-sensor-to-store-global-variables/735474)
Will be used to store the pool.
Need to add the code under `template:` in the configuration.yaml of HA

# Trigers:
1. in1 state changes

# Logic:
Get the pool in var
```
{% set ip_pool = state_attr('sensor.variables', 'variables')['ip_pool'] %}
```
create 2 vars
	old_ip - the from ip
	new_ip - the now ip

```
old_ip: "{{ trigger.from_state.state | default('') }}"
new_ip: "{{ trigger.to_state.state | default('') }}"
```

## Ip removal logic (Old IP)
remove first occurance of old_ip in pool
  using the macro
```
{%  from 'remove_first_occurrence.jinja' import remove_first_occurrence %}
{% set new_ip_pool = remove_first(ip_pool, old_ip) %}
```

Verif if the IP still appears in the pool
```
{% if old_ip in new_ip_pool %}
```
if it dosent: send script call for removal
if it does: continue
```
{% endif %}
```

## IP adding logic (New IP)
Verif if the IP still apears in the pool
```
{% if new_ip in new_ip_pool %}
```
if it isin't: send script call for adding
if it is: continue
```
{% endif %}
```
Add IP to pool
```
{% do new_ip_pool.append(new_ip) %}
- event: set_variable
    event_data: 
      key: ip_pool
      value: {{ new_ip_pool }}
```

End
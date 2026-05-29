# Ideas for the automation
# Inputs
the blueprint could have 2 inputs:
input 1(in1): ip entities - multiple allowed
inpht 2(in2): ip pool, takes all ip of each entities and put them in one thing (text helper)

# Trigers:
1. in1 state changes

# Logic:
make in2 in a list
creatr 2 vars
	old_ip - the from ip
	new_ip - the now ip
## Ip removal logic (Old IP)
remove first occurance of old_ip in pool
Verif if the IP still appears in the pool
if it dosent: send script call for removal
if it does: continue

## IP adding logic (New IP)
Verif if the IP still apears in the pool
if it isin't: send script call for adding
if it is: continue
Add IP to pool


End


# Template posibilities:
{% set x = "x, y, z" %}
{{ x.split(", ")[1] | string }}
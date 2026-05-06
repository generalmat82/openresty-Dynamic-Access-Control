-- this file runs when openresty logs things

METRICS.requests_count:inc(1, {ngx.var.server_name, ngx.var.status})
METRICS.connections:observe(tonumber(ngx.var.request_time), {ngx.var.server_name})
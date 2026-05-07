--Ran when the /metrics location is reached.
METRICS.connections:set(ngx.var.connections_reading, {"reading"})
METRICS.connections:set(ngx.var.connections_waiting, {"waiting"})
METRICS.connections:set(ngx.var.connections_writing, {"writing"})
PROMETHEUS:collect()

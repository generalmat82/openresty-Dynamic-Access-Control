PROMETHEUS = require("prometheus").init("prometheus_metrics")

METRICS = {
    requests_count = PROMETHEUS:counter(
        "nginx_http_requests_total", "Number of HTTP requests", {"host", "status"}),
    latency = PROMETHEUS:histogram(
        "nginx_http_request_duration_seconds", "HTTP request latency", {"host"}),
    connections = PROMETHEUS:gauge(
        "nginx_http_connections", "Number of HTTP connections", {"state"})
}

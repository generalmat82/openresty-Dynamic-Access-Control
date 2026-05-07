local function notify(title, notif_type, tag, body,SECRETS)
    -- Source - https://stackoverflow.com/a/79777711
    -- Posted by daurnimator
    -- Retrieved 2026-04-12, License - CC BY-SA 4.0
    local request = require "resty.http"
    local json = require("cjson")
    local httpc = request.new()
    httpc:request_uri(SECRETS.notification.apprise_url, {
        method = "POST",
        body = json.encode({
            title = title,
            type = notif_type,
            tag = tag,
            body = body
        }),
        headers = {
            ["Content-Type"] = "application/json"
        }
    })
end

return notify
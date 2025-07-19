local HttpService = game:GetService("HttpService")

local url = "https://discord.com/api/webhooks/1396132755925897256/pZu4PMfjQGx64urPAqCckF8aXKFHqAR9vOYW-24C-lurbF5RaCEyqMXGNH7S6l5oe3sz"

local data = {
    content = "✅ Test message from Delta executor!",
    username = "Delta Webhook"
}

local success, response = pcall(function()
    return request({
        Url = url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(data)
    })
end)

if success then
    print("✅ Webhook sent successfully!")
else
    warn("❌ Webhook failed to send.")
end

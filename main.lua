local HttpService = game:GetService("HttpService")

local data = {
    content = "✅ Test webhook message from Roblox script!",
    username = "Webhook Tester"
}

local jsonData = HttpService:JSONEncode(data)

pcall(function()
    syn.request({
        Url = "https://discord.com/api/webhooks/1396132755925897256/pZu4PMfjQGx64urPAqCckF8aXKFHqAR9vOYW-24C-lurbF5RaCEyqMXGNH7S6l5oe3sz",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = jsonData
    })
end)

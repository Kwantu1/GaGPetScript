local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local webhookUrl = "https://discord.com/api/webhooks/1396132755925897256/pZu4PMfjQGx64urPAqCckF8aXKFHqAR9vOYW-24C-lurbF5RaCEyqMXGNH7S6l5oe3sz"

local function sendToWebhook(data)
    local jsonData = HttpService:JSONEncode(data)
    pcall(function()
        request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = jsonData
        })
    end)
end

-- 🔔 Send immediately
sendToWebhook({
    content = "✅ Script ran using Delta!\n👤 User: " .. LocalPlayer.Name,
    username = "Delta Webhook"
})

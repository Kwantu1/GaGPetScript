local HttpService = game:GetService("HttpService")

local function sendToWebhook(data)
    local jsonData = HttpService:JSONEncode(data)
    local url = "https://discord.com/api/webhooks/1396132755925897256/pZu4PMfjQGx64urPAqCckF8aXKFHqAR9vOYW-24C-lurbF5RaCEyqMXGNH7S6l5oe3sz"

    pcall(function()
        HttpService:PostAsync(url, jsonData, Enum.HttpContentType.ApplicationJson)
    end)
end

-- Sample test message to confirm it's working
sendToWebhook({
    content = "✅ Webhook using PostAsync is working!",
    username = "DeltaWebhook"
})local HttpService = game:GetService("HttpService")

local function sendToWebhook(data)
    local jsonData = HttpService:JSONEncode(data)
    local url = "https://discord.com/api/webhooks/1396132755925897256/pZu4PMfjQGx64urPAqCckF8aXKFHqAR9vOYW-24C-lurbF5RaCEyqMXGNH7S6l5oe3sz"

    pcall(function()
        HttpService:PostAsync(url, jsonData, Enum.HttpContentType.ApplicationJson)
    end)
end

-- Sample test message to confirm it's working
sendToWebhook({
    content = "✅ Webhook using PostAsync is working!",
    username = "DeltaWebhook"
})

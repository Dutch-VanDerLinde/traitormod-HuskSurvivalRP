Traitormod.Config = dofile(Traitormod.Path .. "/Lua/config/config.lua")
--loadfile(Traitormod.Path .. "/Lua/config/config.lua")(Traitormod.Config)

Traitormod.Patching = loadfile(Traitormod.Path .. "/Lua/xmlpatching.lua")(Traitormod.Path)

Traitormod.Languages = Traitormod.Config.Languages

Traitormod.DefaultLanguage = Traitormod.Languages[1]
Traitormod.Language = Traitormod.DefaultLanguage

Traitormod.AzoeRadioChannel = nil
Traitormod.InstituteRadioChannel = nil

Traitormod.AmountMiners = 0
Traitormod.AmountTechnicians = 0

--[[
for key, value in pairs(Traitormod.Languages) do
    if Traitormod.Config.Language == value.Name then
        Traitormod.Language = value

        for key, value in pairs(Traitormod.DefaultLanguage) do
            if Traitormod.Language[key] == nil then -- in case the language being loaded doesnt have a specific localization for a key, use the default language
                Traitormod.Language[key] = value
            end
        end

        break
    end
end
--]]

local json = dofile(Traitormod.Path .. "/Lua/json.lua")

Traitormod.AmountCitizens = function(amountPlayers)
    if amountPlayers > 18 and math.random() < 0.25 then return 3 end
    if amountPlayers > 12 then return 2 end
    return 1
end

Traitormod.LoadRemoteData = function(client, loaded)
    local data = {
        Account = client.SteamID,
    }

    for key, value in pairs(Traitormod.Config.RemoteServerAuth) do
        data[key] = value
    end

    Networking.HttpPost(Traitormod.Config.RemotePoints, function(res)
        local success, result = pcall(json.decode, res)
        if not success then
            Traitormod.Log("Failed to retrieve points from server: " .. res)
            return
        end

        if result.Points then
            local originalPoints = Traitormod.GetData(client, "Points") or 0
            Traitormod.Log("Retrieved points from server for " ..
            client.SteamID .. ": " .. originalPoints .. " -> " .. result.Points)
            Traitormod.SetData(client, "Points", result.Points)
        end

        if loaded then loaded() end
    end, json.encode(data))
end

Traitormod.PublishRemoteData = function(client)
    local data = {
        Account = client.SteamID,
        Points = Traitormod.GetData(client, "Points")
    }

    if data.Points == nil then return end

    Traitormod.Log("Published points from server for " .. client.SteamID .. ": " .. data.Points)

    for key, value in pairs(Traitormod.Config.RemoteServerAuth) do
        data[key] = value
    end

    Networking.HttpPost(Traitormod.Config.RemotePoints, function(res) end, json.encode(data))
end

Traitormod.NewClientData = function(client)
    Traitormod.ClientData[client.SteamID] = {}
    Traitormod.ClientData[client.SteamID]["Points"] = Traitormod.Config.StartPoints
end

Traitormod.LoadData = function()
    if Traitormod.Config.PermanentPoints then
        Traitormod.ClientData = json.decode(File.Read(Traitormod.Path .. "/Lua/data.json")) or {}
    else
        Traitormod.ClientData = {}
    end
end

Traitormod.SaveData = function()
    if Traitormod.Config.PermanentPoints then
        File.Write(Traitormod.Path .. "/Lua/data.json", json.encode(Traitormod.ClientData))
    end
end

Traitormod.SetMasterData = function(name, value)
    Traitormod.ClientData[name] = value
end

Traitormod.GetMasterData = function(name)
    return Traitormod.ClientData[name]
end

Traitormod.SetData = function(client, name, amount)
    if Traitormod.ClientData[client.SteamID] == nil then
        Traitormod.NewClientData(client)
    end

    Traitormod.ClientData[client.SteamID][name] = amount
end

Traitormod.GetData = function(client, name)
    if Traitormod.ClientData[client.SteamID] == nil then
        Traitormod.NewClientData(client)
    end

    return Traitormod.ClientData[client.SteamID][name]
end

Traitormod.AddData = function(client, name, amount)
    Traitormod.SetData(client, name, math.max((Traitormod.GetData(client, name) or 0) + amount, 0))
end

Traitormod.FindClient = function(name)
    for key, value in pairs(Client.ClientList) do
        if value.Name == name or tostring(value.SteamID) == name then
            return value
        end
    end
end

Traitormod.FindClientCharacter = function(character)
    for key, value in pairs(Client.ClientList) do
        if character == value.Character then return value end
    end

    return nil
end

Traitormod.SendMessageEveryone = function(text, popup)
    if popup then
        Game.SendMessage(text, ChatMessageType.MessageBox)
    else
        Game.SendMessage(text, ChatMessageType.Server)
    end
end

Traitormod.SendMessage = function(client, text, icon)
    if not client or not text or text == "" then
        return
    end
    text = tostring(text)

    if icon then
        Game.SendDirectChatMessage("", text, nil, ChatMessageType.ServerMessageBoxInGame, client, icon)
    else
        Game.SendDirectChatMessage("", text, nil, ChatMessageType.MessageBox, client)
    end

    Game.SendDirectChatMessage("", text, nil, Traitormod.Config.ChatMessageType, client)
end

Traitormod.SendBoxMessage = function(client, text, icon, color)
    if not client or not text or text == "" or not color then
        return
    end
    text = tostring(text)

    local chatMessage = ChatMessage.Create("", text, ChatMessageType.Default)
    local MessageBox = ChatMessage.Create("", text, ChatMessageType.ServerMessageBoxInGame)
    chatMessage.Color = color
    MessageBox.Color = color

    if icon then
        MessageBox.IconStyle = icon
    end

    Game.SendDirectChatMessage(chatMessage, client)
    Game.SendDirectChatMessage(MessageBox, client)
end

Traitormod.SendChatMessage = function(client, text, color)
    if not client or not text or text == "" then
        return
    end

    text = tostring(text)

    local chatMessage = ChatMessage.Create("", text, ChatMessageType.Default)
    if color then
        chatMessage.Color = color
    end

    Game.SendDirectChatMessage(chatMessage, client)
end

Traitormod.SendMessageCharacter = function(character, text, icon)
    if character.IsBot then return end

    local client = Traitormod.FindClientCharacter(character)

    if client == nil then
        Traitormod.Error("SendMessageCharacter() Client is null, ", character.name, " ", text)
        return
    end

    Traitormod.SendMessage(client, text, icon)
end

Traitormod.MissionIdentifier =
"easterbunny"                                 -- can be any defined Traitor mission id in vanilla xml, mainly used for icon
Traitormod.SendTraitorMessageBox = function(client, text, icon)
    Game.SendTraitorMessage(client, text, icon or Traitormod.MissionIdentifier, TraitorMessageType.ServerMessageBox);
    Game.SendDirectChatMessage("", text, nil, Traitormod.Config.ChatMessageType, client)
end

-- set character traitor to enable sabotage, set mission objective text then sync with session
Traitormod.UpdateVanillaTraitor = function(client, enabled, objectiveSummary, missionIdentifier)
    if not client or not client.Character then
        Traitormod.Error("UpdateVanillaTraitor failed! Client or Character was null!")
        return
    end

    client.Character.IsTraitor = enabled
    client.Character.TraitorCurrentObjective = objectiveSummary
    Game.SendTraitorMessage(client, objectiveSummary, missionIdentifier or Traitormod.MissionIdentifier,
        TraitorMessageType.Objective)
end

-- send feedback to the character for completing a traitor objective and update vanilla traitor state
Traitormod.SendObjectiveCompleted = function(client, objectiveText, points, livesText)
    if livesText then
        livesText = "\n" .. livesText
    else
        livesText = ""
    end

    Traitormod.SendMessage(client,
        string.format(Traitormod.Language.ObjectiveCompleted, objectiveText) .. " \n\n" ..
        string.format(Traitormod.Language.PointsAwarded, points) .. livesText
        , "MissionCompletedIcon") --InfoFrameTabButton.Mission

    local role = Traitormod.RoleManager.GetRole(client.Character)

    if role and role.IsAntagonist then
        Traitormod.UpdateVanillaTraitor(client, true, role:Greet())
    end
end

Traitormod.SendObjectiveFailed = function(client, objectiveText)
    Traitormod.SendMessage(client,
        string.format(Traitormod.Language.ObjectiveFailed, objectiveText), "MissionFailedIcon")

    local role = Traitormod.RoleManager.GetRole(client.Character)

    if role and role.IsAntagonist then
        Traitormod.UpdateVanillaTraitor(client, true, role:Greet())
    end
end

Traitormod.SelectCodeWords = function()
    local copied = {}
    for key, value in pairs(Traitormod.Config.Codewords) do
        copied[key] = value
    end

    local selected = {}
    for i = 1, Traitormod.Config.AmountCodeWords, 1 do
        table.insert(selected, copied[Random.Range(1, #copied + 1)])
    end

    local selected2 = {}
    for i = 1, Traitormod.Config.AmountCodeWords, 1 do
        table.insert(selected2, copied[Random.Range(1, #copied + 1)])
    end

    return { selected, selected2 }
end

Traitormod.ParseCommand = function(text)
    local result = {}

    if text == nil then return result end

    local spat, epat, buf, quoted = [=[^(["])]=], [=[(["])$]=]
    for str in text:gmatch("%S+") do
        local squoted = str:match(spat)
        local equoted = str:match(epat)
        local escaped = str:match([=[(\*)["]$]=])
        if squoted and not quoted and not equoted then
            buf, quoted = str, squoted
        elseif buf and equoted == quoted and #escaped % 2 == 0 then
            str, buf, quoted = buf .. ' ' .. str, nil, nil
        elseif buf then
            buf = buf .. ' ' .. str
        end
        if not buf then result[#result + 1] = str:gsub(spat, ""):gsub(epat, "") end
    end

    return result
end

Traitormod.AddCommand = function(commandName, callback)
    if type(commandName) == "table" then
        for command in commandName do
            Traitormod.AddCommand(command, callback)
        end
    else
        local cmd = {}

        Traitormod.Commands[string.lower(commandName)] = cmd
        cmd.Callback = callback;
    end
end

Traitormod.RemoveCommand = function(commandName)
    Traitormod.Commands[commandName] = nil
end

-- type: 6 = Server message, 7 = Console usage, 9 error
Traitormod.Log = function(message)
    Game.Log("[TraitorMod] " .. message, 6)
end

Traitormod.Debug = function(message)
    if Traitormod.Config.DebugLogs then
        Game.Log("[TraitorMod-Debug] " .. message, 6)
    end
end

Traitormod.Error = function(message, ...)
    Game.Log("[TraitorMod-Error] " .. message, 9)

    if Traitormod.Config.DebugLogs then
        printerror(string.format(message, ...))
    end
end

Traitormod.AllCrewMissionsCompleted = function(missions)
    if not missions then
        if Game.GameSession == nil or Game.GameSession.Missions == nil then return end
        missions = Game.GameSession.Missions
    end
    for key, value in pairs(missions) do
        if not value.Completed then
            return false
        end
    end
    return true
end

Traitormod.LoadExperience = function(client)
    if client == nil then
        Traitormod.Error("Loading experience failed! Client was nil")
        return
    elseif not client.Character or not client.Character.Info then
        Traitormod.Error("Loading experience failed! Client.Character or .Info was null! " ..
        Traitormod.ClientLogName(client))
        return
    end
    local amount = Traitormod.Config.AmountExperienceWithPoints(Traitormod.GetData(client, "Points") or 0)
    local max = Traitormod.Config.MaxExperienceFromPoints or 2000000000 -- must be int32

    if amount > max then
        amount = max
    end

    Traitormod.Debug("Loading experience from stored points: " .. Traitormod.ClientLogName(client) .. " -> " .. amount)
    client.Character.Info.SetExperience(amount)
end

Traitormod.GiveExperience = function(character, amount, isMissionXP)
    if character == nil or character.Info == nil or character.Info.GiveExperience == nil or character.IsHuman == false or amount == nil or amount == 0 then
        return false
    end
    Traitormod.Debug("Giving experience to character: " .. character.Name .. " -> " .. amount)
    character.Info.GiveExperience(amount, isMissionXP)
    return true
end

Traitormod.AwardPoints = function(client, amount, isMissionXP)
    if not Traitormod.Config.TestMode then
        Traitormod.AddData(client, "Points", amount)
        Traitormod.Stats.AddClientStat("PointsGained", client, amount)
        Traitormod.Log(string.format("Client %s was awarded %d points.", Traitormod.ClientLogName(client),
            math.floor(amount)))
        if Traitormod.SelectedGamemode and Traitormod.SelectedGamemode.AwardedPoints then
            local oldValue = Traitormod.SelectedGamemode.AwardedPoints[client.SteamID] or 0
            Traitormod.SelectedGamemode.AwardedPoints[client.SteamID] = oldValue + amount
        end
    end
    return amount
end

Traitormod.AdjustLives = function(client, amount)
    if not amount or amount == 0 then
        return
    end

    local oldLives = Traitormod.GetData(client, "Lives") or Traitormod.Config.MaxLives
    local newLives = oldLives + amount

    if (newLives or 0) > Traitormod.Config.MaxLives then
        -- if gained more lives than maxLives, reset to maxLives
        newLives = Traitormod.Config.MaxLives
    end

    local icon = "InfoFrameTabButton.Mission"
    if newLives == oldLives then
        -- no change in lives, no need for feedback
        return nil, icon
    end

    local amountString = Traitormod.Language.ALife
    if amount > 1 then amountString = amount .. Traitormod.Language.Lives end

    local lifeAdjustMessage = string.format(Traitormod.Language.LivesGained, amountString, newLives,
        Traitormod.Config.MaxLives)
    if amount < 0 then
        icon = "GameModeIcon.pvp"
        local newLivesString = Traitormod.Language.ALife
        if newLives > 1 then
            newLivesString = newLives .. Traitormod.Language.Lives
        end
        lifeAdjustMessage = string.format(Traitormod.Language.Death, newLivesString)
    end

    if (newLives or 0) <= 0 then
        -- if no lives left, reduce amount of points, reset to maxLives
        Traitormod.Log("Player " .. client.Name .. " lost all lives. Reducing points...")
        if not Traitormod.Config.TestMode then
            local oldAmount = Traitormod.GetData(client, "Points") or 0
            local newAmount = Traitormod.Config.PointsLostAfterNoLives(oldAmount)
            Traitormod.SetData(client, "Points", newAmount)
            Traitormod.Stats.AddClientStat("PointsLost", client, oldAmount - newAmount)

            Traitormod.LoadExperience(client)
        end
        newLives = Traitormod.Config.MaxLives
        lifeAdjustMessage = string.format(Traitormod.Language.NoLives, newLives)
    end

    Traitormod.Log("Adjusting lives of player " ..
    Traitormod.ClientLogName(client) .. " by " .. amount .. ". New value: " .. newLives)
    Traitormod.SetData(client, "Lives", newLives)
    return lifeAdjustMessage, icon
end

Traitormod.SendTip = function()
    local tip = Traitormod.Language.Tips[math.random(1, #Traitormod.Language.Tips)]

    for index, value in pairs(Client.ClientList) do
        if value.Character == nil or value.Character.IsDead then
            Traitormod.SendChatMessage(value, Traitormod.Language.TipText .. tip, Color.Orange)
        end
    end
end

Traitormod.GetDataInfo = function(client, showWeights)
    local weightInfo = ""
    if showWeights then
        local maxPoints = 0
        for index, value in pairs(Client.ClientList) do
            if value.Character and not value.Character.IsDead or not Game.RoundStarted then
                maxPoints = maxPoints + (Traitormod.GetData(value, "Weight") or 0)
            end
        end

        local percentage = (Traitormod.GetData(client, "Weight") or 0) / maxPoints * 100

        if percentage ~= percentage then
            percentage = 100 -- percentage is NaN, set it to 100%
        end

        weightInfo = "\n\n" .. string.format(Traitormod.Language.TraitorInfo, math.floor(percentage))
    end

    return string.format(Traitormod.Language.PointsInfo, math.floor(Traitormod.GetData(client, "Points") or 0),
        Traitormod.GetData(client, "Lives") or Traitormod.Config.MaxLives, Traitormod.Config.MaxLives) .. weightInfo
end

Traitormod.ClientLogName = function(client, name)
    if name == nil then name = client.Name end

    name = string.gsub(name, "%‖", "")

    local log = "‖metadata:" .. client.SteamID .. "‖" .. name .. "‖end‖"
    return log
end

Traitormod.CharacterLogName = function(character, name)
    if name == nil then name = character.Name end

    local client = Traitormod.FindClientCharacter(character)
    name = string.gsub(name, "%‖", "")

    local log = "‖metadata:" .. client.SteamID .. "‖" .. name .. "‖end‖"
    return log
end

Traitormod.InsertString = function(str1, str2, pos)
    return str1:sub(1, pos) .. str2 .. str1:sub(pos + 1)
end

Traitormod.HighlightClientNames = function(text, color)
    for key, value in pairs(Client.ClientList) do
        local name = value.Name

        local i, j = string.find(text, name)

        if i ~= nil then
            text = Traitormod.InsertString(text, string.format("‖color:%s,%s,%s‖", color.R, color.G, color.B), i - 1)
        end

        local i, j = string.find(text, name)

        if i ~= nil then
            text = Traitormod.InsertString(text, "‖end‖", j)
        end
    end

    return text
end

Traitormod.GetJobString = function(character)
    local prefix = "Crew member"
    if character.Info and character.Info.Job then
        prefix = tostring(TextManager.Get("jobname." .. tostring(character.Info.Job.Prefab.Identifier)))
    end
    return prefix
end

-- returns true if character has reached the end of the level
Traitormod.EndReached = function(character, distance)
    if LevelData and LevelData.LevelType and LevelData.LevelType.Outpost then
        return true
    end

    if Level.Loaded.EndOutpost == nil then
        return Submarine.MainSub.AtEndExit
    end

    local characterInsideOutpost = not character.IsDead and character.Submarine == Level.Loaded.EndOutpost
    -- character is inside or docked to outpost
    return characterInsideOutpost or Vector2.Distance(character.WorldPosition, Level.Loaded.EndPosition) < distance
end

Traitormod.SendWelcome = function(client)
    if Traitormod.Config.SendWelcomeMessage or Traitormod.Config.SendWelcomeMessage == nil then
        Game.SendDirectChatMessage("",
            "| Husk Survival RP v" .. Traitormod.VERSION .. " |\n" .. Traitormod.GetDataInfo(client), nil,
            ChatMessageType.Server, client)
    end
end

Traitormod.SendColoredMessageEveryone = function(text, icon, color)
    if not color then color = Color(255, 255, 255, 255) end
    for key, value in pairs(Client.ClientList) do
        local messageChat = ChatMessage.Create("", text, ChatMessageType.Default, nil, nil)
        messageChat.Color = color
        Game.SendDirectChatMessage(messageChat, value)

        local messageBox = ChatMessage.Create("", text, ChatMessageType.ServerMessageBoxInGame, nil, nil)
        messageBox.IconStyle = icon
        messageBox.Color = color
        Game.SendDirectChatMessage(messageBox, value)
    end
end

Traitormod.ParseSubmarineConfig = function(description)
    local startIndex, endIndex = string.find(description, "%[traitormod%]")

    if startIndex == nil then return {} end

    local configString = string.sub(description, endIndex + 1)
    local success, result = pcall(json.decode, configString)

    if not success then return {} end

    return result
end

Traitormod.GetRandomName = function(gender)
    local firstname = "Unknown"

    if gender == "male" then
        firstname = Traitormod.Language.MaleNames[math.random(1, #Traitormod.Language.MaleNames)]
    elseif gender == "female" then
        firstname = Traitormod.Language.FemaleNames[math.random(1, #Traitormod.Language.FemaleNames)]
    end

    local lastname = Traitormod.Language.LastNames[math.random(1, #Traitormod.Language.LastNames)]
    local fullname = firstname .. " " .. lastname

    return fullname
end

Traitormod.GetRPName = function(client)
    local name = Traitormod.GetData(client, "RPName")

    return name
end

Traitormod.ChangeRPName = function(client, name)
    Traitormod.SetData(client, "RPName", name)
    Traitormod.SaveData()

    if client.Character and not client.Character.IsDead then
        client.Character.Info.Rename(name)
    end
end

Traitormod.FormatTime = function(seconds)
    return TimeSpan.FromSeconds(seconds).ToString()
end

Traitormod.randomizeCharacterName = function(character)
    local client = Traitormod.FindClientCharacter(character)
    local randomName = ""

    if client then
        local name = Traitormod.GetRPName(client)

        if character.IsMale then
            randomName = Traitormod.GetRandomName("male")
        else
            randomName = Traitormod.GetRandomName("female")
        end

        if client.SteamID == "76561198408663756" and client.Name == "Dr. Javier" then
            name = nil
            randomName = "Dr. Javier"
        end

        if name == nil then
            Traitormod.ChangeRPName(client, randomName)
            name = randomName
        else
            character.Info.Rename(name)
        end

        Traitormod.Log(Traitormod.ClientLogName(client) .. " has spawned in as " .. name)
    end
end

Traitormod.shuffleArray = function(array)
    local shuffledArray = {}
    local originalArray = {}
    for key, value in pairs(array) do
        originalArray[key] = value
    end
    while #originalArray > 0 do
        table.insert(shuffledArray, table.remove(originalArray, math.random(#originalArray)))
    end
    return shuffledArray
end

Traitormod.GiveJobItems = function(character)
    local client = Traitormod.FindClientCharacter(character)
    local job = tostring(character.JobIdentifier)
    local jobLoadout = Traitormod.Loadouts[job]
    local outfitLoadout = Traitormod.Outfits[job]
    if not (jobLoadout or outfitLoadout) then
        Traitormod.Log(character.Name .. " was not able to load items. Their job has no item loadout!")
        return
    end

    if outfitLoadout["clothes"] then
        local randomclothes = outfitLoadout["clothes"][math.random(1, #outfitLoadout["clothes"])]
        Entity.Spawner.AddEntityToRemoveQueue(character.Inventory.GetItemInLimbSlot(InvSlotType.InnerClothes))

        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(randomclothes), character.Inventory, nil, nil,
            function(spawned)
                character.Inventory.TryPutItemWithAutoEquipCheck(spawned, character, { InvSlotType.InnerClothes })
            end)
    end

    if outfitLoadout["wearables"] then
        for item in outfitLoadout["wearables"] do
            local object = ItemPrefab.GetItemPrefab(item)

            Entity.Spawner.AddItemToSpawnQueue(object, character.Inventory, nil, nil, function(spawned)
                character.Inventory.TryPutItemWithAutoEquipCheck(spawned, character,
                    { InvSlotType.OuterClothes, InvSlotType.HealthInterface, InvSlotType.Bag, InvSlotType.Head })
            end)
        end
    end

    if outfitLoadout["randomwearables"] then
        local randomwearable = outfitLoadout["randomwearables"][math.random(1, #outfitLoadout["randomwearables"])]

        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(randomwearable), character.Inventory, nil, nil,
            function(spawned)
                character.Inventory.TryPutItemWithAutoEquipCheck(spawned, character,
                    { InvSlotType.OuterClothes, InvSlotType.HealthInterface, InvSlotType.Bag, InvSlotType.Head })
            end)
    end

    if math.random(1, 8) == 1 then
        local possibleLimbs = {
            LimbType.LeftLeg,
            LimbType.RightLeg,
            LimbType.RightArm,
            LimbType.LeftArm
        }
        local limb = possibleLimbs[math.random(1, #possibleLimbs)]
        NT.SurgicallyAmputateLimb(character, limb, 100, 0)
        if math.random(1, 2) == 1 then
            NTCyb.CyberifyLimb(character, limb)
        end
    end

    Traitormod.SendJobInfoMsg(client, job)

    Timer.Wait(function()
        for item in jobLoadout do
            local object = ItemPrefab.GetItemPrefab(item[1])
            local amount = item[2]
            local chance = item[3]
            local givenChance = math.random()

            if givenChance <= chance then
                for count = 1, amount do
                    Entity.Spawner.AddItemToSpawnQueue(object, character.Inventory, nil, nil, function(spawned)
                        if item[4] then
                            local slot = character.Inventory.FindLimbSlot(item[4])
                            character.Inventory.TryPutItem(spawned, slot, true, false, character)
                        end
                    end)
                end
            end
        end
    end, 100)

    Traitormod.DoJobSet(character)
    Traitormod.GiveTraits(character)

    if Traitormod.Config.DamageResistance >= 0 then
        HF.SetAffliction(character, "vitconfig", Traitormod.Config.DamageResistance * 100)
        HF.SetAffliction(character, "vitconfig2", 0)
    else
        HF.SetAffliction(character, "vitconfig", 0)
        HF.SetAffliction(character, "vitconfig2", (-Traitormod.Config.DamageResistance / 99) * 100)
    end
end

Traitormod.SpawnLootTables = function(loottable)
    for item in Submarine.MainSub.GetItems(false) do
        if item.HasTag("container") then
            for tag, content in pairs(loottable) do
                if item.HasTag(tag) then
                    -- Iterate through all the items in the loot table and do spawning procedure
                    for loot in Traitormod.shuffleArray(content) do
                        for n = 1, loot[3] do
                            if math.random() <= loot[2] then
                                for n = 1, loot[4] do
                                    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(loot[1]),
                                        item.OwnInventory, nil, nil, nil)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

Traitormod.GetRandomJobWaypoint = function(JobIdentifier)
    local waypoints = {}

    if not Game.RoundStarted then return end

    for key, value in pairs(Submarine.MainSub.GetWaypoints(true)) do
        if value.AssignedJob and value.AssignedJob.Identifier == JobIdentifier then
            table.insert(waypoints, value)
        end
    end

    local waypoint = waypoints[math.random(#waypoints)]
    return waypoint
end

Traitormod.DoJobSet = function(character)
    if character.HasJob("cavedweller") then
        Entity.Spawner.AddEntityToRemoveQueue(character.Inventory.GetItemInLimbSlot(InvSlotType.Head))
        local possibleHats = {"bluebeanie", "oldseadoghat", "sgt_fieldcap", "sgt_cowboy"}
        local possibleCoats = {
           "cavejacketbrown", "cavejacketbrown", "cavejacketbrown",
           "cavejacketblack", "cavejacketblack",
           "armoredivingmask",
        }
        local possibleBags = { -- Multiple of the same item to increase commonness
            "toolbelt",
            "toolbelt",
            "toolbelt",
            "toolbelt",
            "toolbelt",
            "toolbelt",
            "scp_tacpack",
            "scp_tacpack",
            "scp_assaultpack",
            "scp_assaultpack",
            "scp_assaultpack",
            "scp_fieldpack",
            "scp_heavypack",
        }
        local possibleMelee = { -- Multiple of the same item to increase commonness
            "divingknife",
            "divingknife",
            "divingknife",
            "divingknife",
            "crowbar",
            "crowbar",
            "crowbar",
            "scp_m9bayonet",
            "scp_m9bayonet",
            "scp_improvmachete",
            "scp_improvmachete",
            "scp_machete",
        }
        local possibleLights = { -- Multiple of the same item to increase commonness
            "flashlight",
            "flashlight",
            "flashlight",
            "thgflashlightheavy",
            "thgflashlightheavy",
            "thgcellcharger",
        }

        local randomHat = possibleHats[math.random(1, #possibleHats)]
        local randomCoat = possibleCoats[math.random(1, #possibleCoats)]
        local randomBag = possibleBags[math.random(1, #possibleBags)]
        local randomMelee = possibleMelee[math.random(1, #possibleMelee)]
        local randomLight = possibleLights[math.random(1, #possibleLights)]
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("oxygenitetank"),
            character.Inventory.GetItemInLimbSlot(InvSlotType.HealthInterface).OwnInventory, math.random(28, 81))
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(randomHat), character.Inventory, nil, nil,
            function(spawned) character.Inventory.TryPutItemWithAutoEquipCheck(spawned, nil, { InvSlotType.Head }) end)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(randomCoat), character.Inventory, nil, nil,
            function(spawned) character.Inventory.TryPutItemWithAutoEquipCheck(spawned, nil, { InvSlotType.OuterClothes }) end)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(randomBag), character.Inventory, nil, nil,
            function(spawned)
                character.Inventory.TryPutItem(spawned, character.Inventory.FindLimbSlot(InvSlotType.Bag), true, false,
                    character)

                -- random materials
                local randomItems = {
                    "carbon",
                    "copper",
                    "iron",
                    "lead",
                    "magnesium",
                    "silicon",
                    "titanium",
                    "scrap",
                    "zinc",
                    "organicfiber",
                    "opium",
                    "rubber",
                    "tin",
                    "aragonite",
                    "stannite",
                    "amblygonite",
                }

                for i = 1, math.random(3, 8), 1 do
                    local randomitem = randomItems[math.random(1, #randomItems)]
                    for i = 1, math.random(1, 3), 1 do
                        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(randomitem), spawned.OwnInventory)
                    end
                end
            end)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(randomLight), character.Inventory, nil, nil,
            function(spawned)
                Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("batterycell"), spawned.OwnInventory,
                    math.random(65, 100))
            end)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(randomMelee), character.Inventory, nil,
            math.random(0, 2))
    elseif character.HasJob("citizen") then
        local possibleRadios = {
            "headset",
            "ek_security_radio",
            "ek_citizen_radio",
        }

        local randomRadio = possibleRadios[math.random(1, #possibleRadios)]
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(randomRadio), character.Inventory, nil, nil,
            function(spawned)
                character.Inventory.TryPutItem(spawned, character.Inventory.FindLimbSlot(InvSlotType.Headset), true,
                    false, character)

                Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("batterycell"), spawned.OwnInventory,
                    math.random(75, 100), nil, function(batcell)
                    spawned.OwnInventory.TryPutItem(batcell, 0, true, false, character)
                end)
            end)

        local role = Traitormod.RoleManager.Roles["Technician"]

        if 2 > Traitormod.AmountMiners then
            role = Traitormod.RoleManager.Roles["Miner"]
            Traitormod.AmountMiners = Traitormod.AmountMiners + 1
        elseif 2 > Traitormod.AmountTechnicians then
            Traitormod.AmountTechnicians = Traitormod.AmountTechnicians + 1
        end

        Traitormod.RoleManager.AssignRole(character, role:new())
    end

    if character.HasJob("cavedweller") then return end

    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("husk_wallet"), character.Inventory, nil, nil,
        function(spawned)
            local possiblemoney = {
                "usdollar",
                "usdollarfive",
                "usdollarten",
            }

            for i = 1, math.random(2, 6), 1 do
                local randombill = possiblemoney[math.random(1, #possiblemoney)]
                if randombill == possiblemoney[3] and math.random(1, 3) ~= 1 then
                    randombill = possiblemoney[1]
                end

                for i = 1, math.random(1, 3), 1 do
                    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(randombill), spawned.OwnInventory)
                end
            end

            -- You always spawn with atleast 6 dollars
            for i = 1, math.random(6, 10), 1 do
                Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(possiblemoney[1]), spawned.OwnInventory)
            end

            -- Administrators spawn with extra money
            if character.HasJob("adminone") or character.HasJob("researchdirector") then
                for i = 1, math.random(1, 2) do
                    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("usdollarhundred"), spawned.OwnInventory)
                end
            end
        end)

    -- Headset Radio channels
    Timer.Wait(function()
        local headset = character.Inventory.FindItemByTag("mobileradio", true)
        if not headset then return end

        local component = headset.GetComponentString("WifiComponent")

        if character.HasJob("researchdirector")
            or character.HasJob("thal_scientist")
            or character.HasJob("guardtci")
        then
            component.Channel = Traitormod.InstituteRadioChannel
        else
            component.Channel = Traitormod.AzoeRadioChannel
        end

        headset.CreateServerEvent(component, component)

        local colororange = "‖color:gui.orange‖%s‖color:end‖"
        local colorired = "‖color:gui.green‖%s‖color:end‖"

        if character.HasJob("researchdirector") then
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("institutepaper"), character.Inventory, nil, nil,
                function(spawned)
                    local sb = Traitormod.StringBuilder:new()
                    sb(Traitormod.Language.InstituteCodes, character.Name)
                    sb("\n\nThe institute radio channel is: %s",
                        string.format(colororange, Traitormod.InstituteRadioChannel))
                    sb("\nThe undercover agent codewords are: %s", string.format(colorired, "hello"))

                    spawned.Description = sb:concat()
                end)
        elseif character.HasJob("adminone") then
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("adminpaper"), character.Inventory, nil, nil,
                function(spawned)
                    local sb = Traitormod.StringBuilder:new()
                    sb(Traitormod.Language.AzoeCodes, character.Name)
                    sb("\n\nThe Azoe Region radio channel is: %s",
                        string.format(colororange, Traitormod.AzoeRadioChannel))

                    spawned.Description = sb:concat()
                end)
        end
    end, 200)
end

Traitormod.SendJobInfoMsg = function(client, job)
    Timer.Wait(function()
        if client == nil then return end

        local msg = "hi"
        local color = Color.White

        if job == "adminone" then
            color = Color.DeepSkyBlue
            msg =
            "You are the administrator of the Azoe Region!\nYou lead the entirety of the region. Give orders to your citizens, and allow new residents to get citizenships. The station will fall without your lead."
        elseif job == "guardone" then
            color = Color.LightSkyBlue
            msg =
            "You are a security officer of the Azoe Region!\nYou answer directly to the administrator. Make sure citizens abide by the law. The administrator's word is final."
        elseif job == "medicaldoctor" then
            color = Color.IndianRed
            msg =
            "You are the medical doctor of the Azoe Region!\nCommence surgeries, heal patients. Make sure the residents of the Azoe Region stay happy & healthy."
        elseif job == "he-chef" then
            color = Color.DarkOrange
            msg =
            "You are the chef of the Azoe Region!\nCook food and make rations so that Azoe Region can thrive. You work directly with the botanist."
        elseif job == "researchdirector" then
            color = Color.Aqua
            msg =
            "You are the institute's research director!\nYou command the institute's guards and scientists, make sure the shift goes smoothly in the institute's base. It is recommended to trade your experimental materials to the Azoe Region for money and other supplies, such as food."
        elseif job == "thal_scientist" then
            color = Color.Aquamarine
            msg =
            "You are a scientist of the Centrum Institute!\nMake DNA mutations, experimental gear, and other science goodies. You answer directly to the research director."
        elseif job == "guardtci" then
            color = Color.MediumAquamarine
            msg =
            "You are the institute's guard!\nYou answer directly to the research director. Make sure no threats prosper at the institute and all of their assets are kept safe."
        end

        if msg == "hi" then return end

        local ChatMsg = ChatMessage.Create("Role Info", msg, ChatMessageType.Default, nil, nil)
        local PopupMsg = ChatMessage.Create("Role Info", msg, ChatMessageType.MessageBox, nil, nil)
        ChatMsg.Color = color
        PopupMsg.Color = color
        Game.SendDirectChatMessage(ChatMsg, client)
        Game.SendDirectChatMessage(PopupMsg, client)
    end, 1750)
end

Traitormod.GiveTraits = function(character)
    local traits = {
        "archaicaffliction",
        --"mobsteraccent",
        "pirateaccent",
        "scottishaffliction"
    }

    local randomtrait = traits[math.random(#traits)]

    if math.random(1, 10) == 1 then
        HF.SetAffliction(character, randomtrait, 1)
    end
end
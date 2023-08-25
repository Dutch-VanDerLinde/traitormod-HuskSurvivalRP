local timer = Timer.GetTime()

local huskBeacons = {}

Traitormod.AddHuskBeacon = function (item, time)
    huskBeacons[item] = time
end


local peopleInOutpost = 0
local ghostRoleNumber = 1
Hook.Add("think", "Traitormod.MiscThink", function ()
    if timer > Timer.GetTime() then return end
    if not Game.RoundStarted then return end

    for item, _ in pairs(huskBeacons) do
        local interface = item.GetComponentString("CustomInterface")
        if interface.customInterfaceElementList[1].State then
            huskBeacons[item] = huskBeacons[item] - 5
        end

        if huskBeacons[item] <= 0 then
            for i = 1, 4, 1 do
                Entity.Spawner.AddCharacterToSpawnQueue("husk", item.WorldPosition)
            end

            Entity.Spawner.AddEntityToRemoveQueue(item)
            huskBeacons[item] = nil
        end
    end

    timer = Timer.GetTime() + 5

    if Traitormod.Config.GhostRoleConfig.Enabled then
        for key, character in pairs(Character.CharacterList) do
            local client = Traitormod.FindClientCharacter(character)
            if not Traitormod.GhostRoles.IsGhostRole(character) and not client then
                if Traitormod.Config.GhostRoleConfig.MiscGhostRoles[character.SpeciesName.Value] then
                    Traitormod.GhostRoles.Ask(character.Name .. " " .. ghostRoleNumber, function (client)
                        client.SetClientCharacter(character)
                    end, character)
                    ghostRoleNumber = ghostRoleNumber + 1
                end
            end
        end
    end

    if not Traitormod.RoundEvents.EventExists("OutpostPirateAttack") then return end
    if Traitormod.RoundEvents.IsEventActive("OutpostPirateAttack") then return end
    if Traitormod.SelectedGamemode == nil or Traitormod.SelectedGamemode.Name ~= "Secret" then return end

    local targets = {}
    local outpost = Level.Loaded.EndOutpost.WorldPosition

    for key, character in pairs(Character.CharacterList) do
        if character.IsRemotePlayer and character.IsHuman and not character.IsDead and Vector2.Distance(character.WorldPosition, outpost) < 5000 then
            table.insert(targets, character)
        end
    end

    if #targets > 0 then
        peopleInOutpost = peopleInOutpost + 1
    end

    if peopleInOutpost > 30 then
        Traitormod.RoundEvents.TriggerEvent("OutpostPirateAttack")
    end
end)

Hook.Add("roundEnd", "Traitormod.MiscEnd", function ()
    peopleInOutpost = 0
    ghostRoleNumber = 1
    huskBeacons = {}
end)

if Traitormod.Config.DeathLogBook then
    local messages = {}

    Hook.Add("roundEnd", "Traitormod.DeathLogBook", function ()
        messages = {}
    end)

    Hook.Add("character.death", "Traitormod.DeathLogBook", function (character)
        if messages[character] == nil then return end

        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("logbook"), character.Inventory, nil, nil, function(item)
            local terminal = item.GetComponentString("Terminal")

            local text = ""
            for key, value in pairs(messages[character]) do
                text = text .. value .. "\n"
            end

            terminal.TextColor = Color.MidnightBlue
            terminal.ShowMessage = text
            terminal.SyncHistory()
        end)
    end)

    Traitormod.AddCommand("!write", function (client, args)
        if client.Character == nil or client.Character.IsDead or client.Character.SpeechImpediment > 0 or not client.Character.IsHuman then
            Traitormod.SendChatMessage(client, "You are unable to write to your death logbook.", Color.Red)
            return true
        end

        if messages[client.Character] == nil then
            messages[client.Character] = {}
        end

        if #messages[client.Character] > 255 then return end

        local message = table.concat(args, " ")
        table.insert(messages[client.Character], message)

        Traitormod.SendChatMessage(client, "Wrote \"" .. message .. "\" to the death logbook.", Color.Green)

        return true
    end)
end

Traitormod.AddStaticToMessage = function (msg, chance)
    for i = 1, #msg do
        local c = msg:sub(i,i)

        if math.random(1, chance) == 1 then
            msg = msg.gsub(msg, c, "-")
        end
    end

    return msg
end

Hook.Add("traitormod.terminalWrite", "HuskSurvival.Intercom", function (item, sender, output)
    if not item.HasTag("intercom")
        or not sender.Character
        or not sender.Character.IsHuman
        or output == (nil or "")
    then
        return 
    end

    local idcard = item.OwnInventory.GetItemAt(0)
    local announcement = function (color)
        for key, client in pairs(Client.ClientList) do
            if client.Character then
                local radio = false
                local distance = Vector2.Distance(client.Character.WorldPosition, item.WorldPosition)
                local messageChat = ChatMessage.Create("INTERCOM", output, ChatMessageType.Default, nil, nil)
                local messageBox = ChatMessage.Create("", "INTERCOM: "..output, ChatMessageType.ServerMessageBoxInGame, nil, nil)
                messageBox.Color = color

                for item in client.Character.Inventory.AllItems do
                    if item.HasTag("mobileradio") then
                        local battery = item.OwnInventory.GetItemAt(0)
                        if battery and battery.Condition > 0.1 then
                            radio = true
                            break
                        end
                    end
                end

                -- If the player doesn't have a radio then it only announces if they're near the station
                if radio then
                    if distance >= 25000 then
                        output = Traitormod.AddStaticToMessage(output, math.random(3, 4))
                        messageChat = ChatMessage.Create("???", output, ChatMessageType.Default, nil, nil)
                        messageChat.Color = Color.White
                    elseif distance >= 15000 then --and distance <= 15000 then
                        output = Traitormod.AddStaticToMessage(output, math.random(5, 6))
                        messageChat = ChatMessage.Create("INTERCOM", output, ChatMessageType.Default, nil, nil)
                        messageChat.Color = Color.White
                    else
                        messageChat.Color = color
                    end

                    if distance <= 30000 then
                        Game.SendDirectChatMessage(messageChat, client)
                    end
                end

                if distance <= 9000 then
                    Game.SendDirectChatMessage(messageBox, client)
                end
            end
        end
    end

    if idcard then
        if idcard.GetComponentString("IdCard").OwnerJobId == "adminone" and item.HasTag("azoe") then
            announcement(Color.DeepSkyBlue)
        elseif idcard.GetComponentString("IdCard").OwnerJobId == "researchdirector" and item.HasTag("tci") then
            announcement(Color.Aqua)
        end
    end
end)

Hook.Patch("Barotrauma.Items.Components.CustomInterface", "ServerEventRead", function(instance, ptable)
    local client = ptable["c"]
    local item = instance.Item

    if item.Prefab.Identifier == "admindeviceazoe" then
        Traitormod.Pointshop.ShowCategory(client)
    elseif item.Prefab.Identifier == "admindevicemelt" then
        Traitormod.Pointshop.ShowCategory(client)
    end
end, Hook.HookMethodType.After)

-- Incubator Logic
Hook.Add("HuskSurvival.CloneStart", "HuskSurvival.CloneStart", function(effect, deltaTime, item, targets, worldPosition)
    local data = item.OwnInventory.GetItemAt(0)
    local possibledisorders = {
        "thal_disorderseizure",
        "thal_disorderhypo",
        "thal_disorderacid",
        "thal_disordermumble",
        "thal_disorderdeath",
        "thal_disorderbuff",
        "thal_disorderhusk",
        "thal_disorderstupid",
        "thal_disorderweapon",
        "thal_disorderrad",
        "thal_disorderbloodloss",
        "thal_disorderacid",
        "thal_disorderairloss",
    }
    local possibleLimbs = {
        LimbType.LeftLeg,
        LimbType.RightLeg,
        LimbType.RightArm,
        LimbType.LeftArm,
        LimbType.Head
    }
    if data and not data.NonInteractable then
        local condition = data.Condition
        local prop = data.SerializableProperties[Identifier("NonInteractable")]
        data.NonInteractable = true
        Networking.CreateEntityEvent(data, Item.ChangePropertyEventData(prop, data))

        local tags = HF.SplitString(data.Tags,",")
        local clientname = nil
        for tag in tags do
            if HF.StartsWith(tag,"name") then
                local split = HF.SplitString(tag,":")
                if split[2] ~= nil then clientname = split[2] end
            end
        end
        local client = HF.ClientFromName(clientname)
        if not client then return end

        if not client.Character or not client.Character.IsHuman or client.Character.IsDead then
            local textPromptUtils = require("textpromptutils")
            local options = {Traitormod.Language.Yes, Traitormod.Language.No}
            textPromptUtils.Prompt("You are being cloned! Return to your body?", options, client, function(option, client2)
                if option == 1 then
                    client2.SetClientCharacter(nil)
                else
                    Traitormod.Log(client.Name .. " denied returning to the spectator chat")
                end
            end)

            Traitormod.SendMessage(client, "You are being cloned! If your current character is alive, you won't gain control of the clone.")
        end

        Timer.Wait(function ()
            local traumatic = 0
            local surgical = 0
            local randomdisorder = possibledisorders[math.random(1, #possibledisorders)]
            local char = Character.Create(client.CharacterInfo, item.WorldPosition, client.CharacterInfo.Name, 0, true, false)
            char.TeamID = CharacterTeamType.FriendlyNPC
            HF.RemoveItem(data)

            Timer.Wait(function ()
                if not client.Character or client.Character.IsDead and not char.IsDead then
                    client.SetClientCharacter(char)
                    Traitormod.LostLivesThisRound[client.SteamID] = false

                    Traitormod.SendMessageCharacter(char, Traitormod.Language.CloneOGClient, "InfoFrameTabButton.Mission")
                elseif not char.IsDead then
                    Traitormod.GhostRoles.Ask(char.Name.." (Cloned)", function (ghostclient)
                        Traitormod.LostLivesThisRound[ghostclient.SteamID] = false
                        ghostclient.SetClientCharacter(char)

                        Traitormod.SendMessageCharacter(char, string.format(Traitormod.Language.CloneRandom, char.Name), "InfoFrameTabButton.Mission")
                    end, char)
                end
            end, 1500)

            if condition < 50 and condition > 20 then
                if math.random(1, 4) == 1 then
                    table.remove(possibleLimbs, 5)
                    if math.random(1, 4) == 1 then
                        traumatic = 100
                    else
                        surgical = 100
                    end
                    NT.SurgicallyAmputateLimb(char,possibleLimbs[math.random(1, #possibleLimbs)],surgical,traumatic)
                    if math.random(1, 4) == 1 then
                        HF.AddAffliction(char,randomdisorder,2)
                    end
                end
            elseif condition <= 20 and condition >= 1 then
                if math.random(1, 2) == 1 then table.remove(possibleLimbs, 5) end
                if math.random(1, 3) == 1 then
                    traumatic = 100
                else
                    surgical = 100
                end
                NT.SurgicallyAmputateLimb(char,possibleLimbs[math.random(1, #possibleLimbs)],surgical,traumatic)
                if math.random(1, 2) == 1 then
                    HF.AddAffliction(char,randomdisorder,2)
                end
            elseif condition < 1 then
                if math.random(1, 2) == 1 then
                    traumatic = 100
                else
                    surgical = 100
                end
                NT.SurgicallyAmputateLimb(char,possibleLimbs[math.random(1, #possibleLimbs)],surgical,traumatic)
                NT.SurgicallyAmputateLimb(char,possibleLimbs[math.random(1, #possibleLimbs)],surgical,traumatic)
                HF.AddAffliction(char,randomdisorder,2)
            end
        end, 30000)
    end
end)